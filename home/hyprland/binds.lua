local mod = "SUPER"
local terminal = "ghostty"

hl.bind(mod .. " + RETURN", hl.dsp.exec_cmd(terminal))
hl.bind(mod .. " + Q", hl.dsp.window.close())
hl.bind(mod .. " + SHIFT + E", hl.dsp.exit())
hl.bind(mod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mod .. " + T", hl.dsp.exec_cmd("~/nixos/home/noctalia/theme-switch.sh"))
hl.bind(mod .. " + U", hl.dsp.exec_cmd("noctalia msg session lock"))
hl.bind(mod .. " + SPACE", hl.dsp.exec_cmd("noctalia msg panel-toggle launcher"))
hl.bind(mod .. " + TAB", hl.dsp.exec_cmd("hyprctl dispatch overview:toggle"))
hl.bind(mod .. " + CTRL + F", hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }))

-- Toggles the active window's width between half and a quarter of the
-- monitor's width (full height), rather than a true fullscreen.
hl.bind(mod .. " + SHIFT + F", function()
	local win = hl.get_active_window()
	if not win then return end
	local mon = win.monitor
	if not mon then return end

	local half = math.floor(mon.size.x * 0.5)
	local quarter = math.floor(mon.size.x * 0.25)
	local atHalf = math.abs(win.size.x - half) < 10

	hl.dispatch(hl.dsp.window.resize({
		x = atHalf and quarter or half,
		y = mon.size.y,
		relative = false,
	}))
end)

-- Hold SUPER + right-click drag to resize, same as left-click drag moves -
-- works on tiled windows too (adjusts the split), not just floating ones.
hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

for i = 1, 10 do
	local key = i % 10
	hl.bind(mod .. " + " .. key, hl.dsp.focus({ workspace = i }))
	hl.bind(mod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Navigation around tiling
hl.bind(mod .. " + l", hl.dsp.focus({direction = "right"}))
hl.bind(mod .. " + h", hl.dsp.focus({direction = "left"}))
hl.bind(mod .. " + k", hl.dsp.focus({direction = "up"}))
hl.bind(mod .. " + j", hl.dsp.focus({direction = "down"}))

-- Move windows around
hl.bind(mod .. " + SHIFT + l", hl.dsp.window.swap({direction = "right"}))
hl.bind(mod .. " + SHIFT + h", hl.dsp.window.swap({direction = "left"}))
hl.bind(mod .. " + SHIFT + k", hl.dsp.window.swap({direction = "up"}))
hl.bind(mod .. " + SHIFT + j", hl.dsp.window.swap({direction = "down"}))
