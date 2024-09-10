VERSION = "1.0.0"

local micro = import("micro")
local config = import("micro/config")

function init()
	config.MakeCommand("open_ref", open_ref, config.NoComplete)
end

function open_ref(bp)
	os.execute("cat " .. bp.Buf.AbsPath .. " | grep '^\\[' | rofi -dmenu -p 'Choose URL:' | cut -d ' ' -f 2 | xargs $BROWSER")
end
