-- `local` doesn't cross `require()` boundaries in Lua, so this file defines
-- its own mod/terminal rather than reaching into hyprland.lua's locals.
local mod = "SUPER"
local terminal = "ghostty"

hl.bind(mod .. " + RETURN", hl.dsp.exec_cmd(terminal))
hl.bind(mod .. " + Q", hl.dsp.window.close())
hl.bind(mod .. " + SHIFT + E", hl.dsp.exit())
hl.bind(mod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mod .. " + T", hl.dsp.exec_cmd("~/nixos/home/noctalia/theme-switch.sh"))

-- SUPER + [0-9] focuses a workspace, SUPER + SHIFT + [0-9] moves the active
-- window to it. 10 is bound to the "0" key, matching Hyprland's own example.
for i = 1, 10 do
	local key = i % 10
	hl.bind(mod .. " + " .. key, hl.dsp.focus({ workspace = i }))
	hl.bind(mod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end
