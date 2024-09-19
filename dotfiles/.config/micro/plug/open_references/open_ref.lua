VERSION = "1.0.0"

local micro = import("micro")
local config = import("micro/config")

function init()
	config.MakeCommand("open_ref", open_ref, config.NoComplete)
end

-- For regex: https://stackoverflow.com/questions/7109143/what-characters-are-valid-in-a-url

function open_ref(bp)
	--os.execute("cat " .. bp.Buf.AbsPath .. " | grep '^\\[' | rofi -dmenu -p 'Choose URL:' | cut -d ' ' -f 2 | xargs $BROWSER")
	os.execute("grep http " .. bp.Buf.AbsPath .. " | rofi -dmenu -i -p \"Select URL\" | grep -Eo \"http[A-Za-z0-9._~:/?#@!$&'\(\)*+,;%=]*\" | xargs $BROWSER")
end
