#!/usr/bin/env python3

import i3ipc
import sys

conn = i3ipc.Connection()

tree = conn.get_tree()


def focused_order(node):
	"""Iterate through the children of "node" in most recently focused order."""
	for focus_id in node.focus:
		yield next(n for n in node.nodes if n.id == focus_id)


def focused_child(node):
	"""Return the most recently focused child of "node"."""
	return next(focused_order(node))


def is_in_line(old, new, direction):
	"""
	Return true if container "new" can reasonably be considered to be in
	direction "direction" of container "old".
	"""
	if direction in ["up", "down"]:
		return new.rect.x <= old.rect.x + old.rect.width*0.5 \
				and new.rect.x + new.rect.width >= old.rect.x + old.rect.width*0.5
	elif direction in ["left", "right"]:
		return new.rect.y <= old.rect.y + old.rect.height*0.5 \
				and new.rect.y + new.rect.height >= old.rect.y + old.rect.height*0.5


def output_in_direction(output, window, direction):
	"""
	Return the output in direction "direction" of window "window" on output
	"output".
	"""
	for new in focused_order(tree):
		if new.name == "__i3":
			continue
		if not is_in_line(window, new, direction):
			continue
		orct = output.rect
		nrct = new.rect
		if (direction == "left" and nrct.x + nrct.width == orct.x) \
				or (direction == "right" and nrct.x == orct.x + orct.width) \
				or (direction == "up" and nrct.y + nrct.height == orct.y) \
				or (direction == "down" and nrct.y == orct.y + orct.height):
			return new

	return None


def leaf_in_direction(window, direction):
	"""
	Return the leaf that is *visually* in direction "direction" of the node
	"window". If there are multiple candidates, (usually) pick the most recently
	focused one.
	"""
	if direction in ["left", "right"]:
		splitx = "splith"
	elif direction in ["up", "down"]:
		splitx = "splitv"
	if direction in ["down", "right"]:
		last = -1
		first = 0
		delta = 1
	elif direction in ["up", "left"]:
		last = 0
		first = -1
		delta = -1
	else:
		usage()

	node = window

	# Find innermost parent in which we can move in the desired direction,
	# then move.
	while True:
		parent = node.parent
		if node.type == "workspace":
			node = output_in_direction(parent.parent, window, direction)
			if not node:
				return None
			node = next(n for n in node.nodes if n.type != "dockarea")
			node = focused_child(node)
			break
		if node.type == "floating_con":
			return None
		if node.type != "con":
			raise Exception("not con")
		if not parent:
			raise Exception("no parent")
		if parent.layout == splitx and parent.nodes[last] != node:
			index = parent.nodes.index(node)
			node = parent.nodes[index + delta]
			break
		node = parent

	# Find an appropriate leaf to focus.
	while node.nodes:
		if node.layout in ["tabbed", "stacked"]:
			# Choose most recently focused tab.
			node = focused_child(node)
		elif node.layout == splitx:
			# Choose nearest child to original container.
			node = node.nodes[first]
		else:
			# Choose the most recently focused child that can reasonably be
			# considered adjacent to the original container.
			for new in focused_order(node):
				if is_in_line(window, new, direction):
					node = new
					break
			else:
				# No appropriate child found, just focus any one.
				node = node.nodes[0]

	return node


def focus_direction(direction):
	"""
	Focus the leaf that is *visually* in direction "direction". If there are
	multiple candidates, (usually) pick the most recently focused one.
	"""
	focused = tree.find_focused()
	node = leaf_in_direction(focused, direction)
	if node:
		conn.command(f'[con_id="{node.id}"] focus')


def move_direction(direction, amount):
	"""
	Move the current container in the given direction. I the direct parent is a
	tabbed or stacked container, escape from it.
	"""

	focused = tree.find_focused()

	try:
		amount = int(amount)
	except ValueError:
		print("Bad resize amount given.")
		exit(1)

	if direction in ["left", "right"]:
		tabx = "tabbed"
		taby = "stacked"
	elif direction in ["up", "down"]:
		tabx = "stacked"
		taby = "tabbed"
	else:
		usage()

	parent = focused.parent
	if parent and parent.layout == tabx:
		sibling = next((n for n in parent.nodes if n != focused), None)
		if sibling:
			conn.command(f'layout {taby}; move {direction} {amount} px;'
			             f'[con_id="{sibling.id}"] layout {tabx}')
			return

	conn.command(f"move {direction} {amount} px")


def swap_direction(direction):
	"""
	Swap with the leaf that is *visually* in direction "direction". If there are
	multiple candidates, (usually) pick the most recently focused one.
	"""
	focused = tree.find_focused()
	node = leaf_in_direction(focused, direction)
	if node:
		conn.command(f"swap container with con_id {node.id}")


def focus_tab(direction):
	"""
	Cycle through the innermost stacked or tabbed ancestor container, or through
	floating containers.
	"""
	if direction == "next":
		delta = 1
	elif direction == "prev":
		delta = -1
	else:
		usage()

	node = tree.find_focused()

	# Find innermost tabbed or stacked container, or detect floating.
	while True:
		parent = node.parent
		if not parent or node.type != "con":
			return
		if parent.layout in ["tabbed", "stacked"] or parent.type == "floating_con":
			break
		node = parent

	if parent.type == "floating_con":
		node = parent
		parent = node.parent
		# The order of floating_nodes is not useful, sort it somehow.
		parent_nodes = sorted(parent.floating_nodes, key=lambda n: n.id)
	else:
		parent_nodes = parent.nodes

	index = parent_nodes.index(node)
	node = parent_nodes[(index + delta) % len(parent_nodes)]

	# Find most recently focused leaf in new tab.
	while node.nodes:
		node = focused_child(node)

	conn.command(f'[con_id="{node.id}"] focus')


def move_tab(direction):
	"""
	Move the innermost stacked or tabbed ancestor container.
	"""
	if direction == "next":
		delta = 1
	elif direction == "prev":
		delta = -1
	else:
		usage()

	node = tree.find_focused()

	# Find innermost tabbed or stacked container.
	while True:
		parent = node.parent
		if not parent or node.type != "con":
			return
		if parent.layout in ["tabbed", "stacked"]:
			break
		node = parent

	index = parent.nodes.index(node)

	if 0 <= index + delta < len(parent.nodes):
		other = parent.nodes[index + delta]
		conn.command(f'[con_id="{node.id}"] swap container with con_id {other.id}')


def usage():
	print("Usage: window_tool [focus|swap] [up|down|left|right]")
	print("       window_tool move [up|down|left|right] AMOUNT")
	print("       window_tool [tab-focus|tab-move] [prev|next]")
	exit(1)


def main(command, direction, arg=None):
	if command == "focus" and arg is None:
		focus_direction(direction)
	elif command == "swap" and arg is None:
		swap_direction(direction)
	elif command == "move" and arg is not None:
		move_direction(direction, arg)
	elif command == "tab-focus" and arg is None:
		focus_tab(direction)
	elif command == "tab-move" and arg is None:
		move_tab(direction)
	else:
		usage()


if __name__ == "__main__":
	if len(sys.argv) not in [3, 4]:
		usage()
	main(*sys.argv[1:])
