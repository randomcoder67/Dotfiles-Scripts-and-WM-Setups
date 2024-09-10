function conky_round_width(arg)
	local n = conky_parse(arg)
	x = tonumber(n)
	if x < 10 then
		return x
	end
	return tonumber(string.format("%.1f", x))
end
