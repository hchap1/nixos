local mod = "SUPER"
local terminal = "ghostty"

hl.bind(mod .. " + RETURN", hl.dsp.exec_cmd(terminal))
hl.bind(mod .. " + Q", hl.dsp.window.close())
hl.bind(mod .. " + SHIFT + Q", hl.dsp.window.kill())
hl.bind(mod .. " + SHIFT + E", hl.dsp.exit())
hl.bind(mod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mod .. " + G", function()
	hl.dispatch(hl.dsp.window.float({ action = "enable" }))
	hl.dispatch(hl.dsp.window.center())
end)

hl.bind(mod .. " + SHIFT + U", hl.dsp.exec_cmd("noctalia msg session lock"))
hl.bind(mod .. " + SPACE", hl.dsp.exec_cmd("noctalia msg panel-toggle launcher"))

-- Drag-select a region. See screenshot.sh for why this isn't grimblast -
-- its freeze-frame trick was flickering and sometimes leaking the
-- selection box into the capture.
hl.bind(mod .. " + SHIFT + S", hl.dsp.exec_cmd("~/nixos/home/hyprland/screenshot.sh copy"))
hl.bind(mod .. " + CTRL + SHIFT + S", hl.dsp.exec_cmd("~/nixos/home/hyprland/screenshot.sh save"))

-- Niri-style overview. Hyprspace exposes this as hl.plugin.overview.*
-- (addLuaFunction) rather than a classic string dispatcher - see the
-- overlay bumping its pin in modules/system/hyprland.nix for why that
-- distinction matters under Lua config.
hl.bind(mod .. " + TAB", function() hl.plugin.overview.toggle() end)

-- True fullscreen, borderless (Hyprland suppresses decorations on
-- fullscreen windows automatically) - handled natively by the scrolling
-- layout's own fullscreen handler.
hl.bind(mod .. " + CTRL + F", hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }))

-- Number of distinct columns currently on a workspace (0 if ws is nil).
local function countColumns(ws)
	if not ws then return 0 end

	local seen, count = {}, 0
	for _, w in ipairs(ws:get_windows()) do
		local col = w.layout and w.layout.column
		if col and col.index ~= nil and not seen[col.index] then
			seen[col.index] = true
			count = count + 1
		end
	end
	return count
end

-- Resizes the focused column between a fixed pair of width fractions
-- (of the monitor's width), toggling to whichever of the pair it's
-- currently furthest from. No-ops on floating windows (they have no
-- column). Applies the same toggle whether the column is alone on its
-- workspace or not - the window.open hook below still seeds a lone
-- column at half width, but Win+F/Win+Shift+F cycle it from there like
-- any other column instead of snapping it back to 0.5 every press.
local function cycleColumnWidth(pair)
	local win = hl.get_active_window()
	if not win then return end
	local col = win.layout and win.layout.column
	if not col then return end

	local target = (math.abs(col.width - pair[1]) < 0.02) and pair[2] or pair[1]
	hl.dispatch(hl.dsp.layout("colresize " .. target))
end

-- Terminal-ish range: quarter <-> half monitor width.
hl.bind(mod .. " + F", function() cycleColumnWidth({ 0.25, 0.5 }) end)
-- "Big things" range: half <-> full monitor width.
hl.bind(mod .. " + SHIFT + F", function() cycleColumnWidth({ 0.5, 1.0 }) end)

-- A column that's alone on its workspace defaults to half the monitor's
-- width, not whatever scrolling_width a window rule gave it (e.g.
-- rules.lua's narrower 0.25 default for terminals) - a single tiled
-- window at quarter width looks like a mistake when there's nothing else
-- to fill the rest of the screen. (appearance.lua disables Hyprland's own
-- fullscreen_on_one_column, which used to "solve" this by stretching the
-- lone column to the *entire* screen instead - also wrong, just wrong the
-- other direction, and what made SUPER+F look like it did nothing.)
hl.on("window.open", function(win)
	if countColumns(win and win.workspace) == 1 then
		hl.dispatch(hl.dsp.layout("colresize 0.5"))
	end
end)

-- Focus-follow only slides the view when the focused column would
-- otherwise go off-screen (see appearance.lua's focus_fit_method) - this
-- explicitly centers the focused column on demand instead.
hl.bind(mod .. " + C", hl.dsp.layout("center"))

-- Resets every column on the active workspace to an equal share of the
-- monitor's width.
hl.bind(mod .. " + M", function()
	local win = hl.get_active_window()
	local count = countColumns(win and win.workspace)
	if count == 0 then return end

	hl.dispatch(hl.dsp.layout("colresize all " .. (1 / count)))
end)

-- Hold SUPER + left-click drag to move windows - floats move freely,
-- tiled windows swap/consume into columns.
hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })

-- Hold SUPER + right-click drag to resize, same as left-click drag moves -
-- works on tiled windows too (resizes the column), not just floating ones.
hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- SUPER+<number> is a direct pick, not a scroll - swap to a quick fade
-- instead of the slide used for j/k/relative switches. Swapping style
-- (not disabling the leaf) matters: disabling it was tried first and
-- made Hyprland fall back to the "windows" slide animation instead of
-- no animation at all, which looked worse. Leaving it enabled and just
-- changing style avoids that fallback.
local function focusWorkspaceByNumber(i)
	for _, leaf in ipairs({ "workspaces", "workspacesIn", "workspacesOut" }) do
		hl.animation({ leaf = leaf, enabled = true, speed = 1.5, bezier = "fluidInOut", style = "fade" })
	end
	hl.dispatch(hl.dsp.focus({ workspace = i }))
	for _, leaf in ipairs({ "workspaces", "workspacesIn", "workspacesOut" }) do
		hl.animation({ leaf = leaf, enabled = true, speed = 2.5, bezier = "fluidInOut", style = "slidevert" })
	end
end

for i = 1, 10 do
	local key = i % 10
	hl.bind(mod .. " + " .. key, function() focusWorkspaceByNumber(i) end)
	hl.bind(mod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Column data for the focused window: its column (with sibling windows
-- and index-within-column), or nil if it's not a tiled scrolling window.
local function columnPosition(win)
	local lay = win and win.layout
	if lay and lay.column and lay.index_in_column ~= nil then
		return lay.column, lay.index_in_column
	end
	return nil, nil
end

-- Hyprland's animation "speed" is a fixed duration, not a velocity
-- (2.5 -> 250ms, always - see animations.lua's "workspaces" leaf). So a
-- single dispatch straight to workspace+2 covers twice the distance in
-- that same 250ms - i.e. it's not jerky, but it IS moving at roughly
-- double the speed of a normal single hop, which still reads as
-- "inconsistent." And firing two independent dispatches back to back
-- risks the second one interrupting/retargeting the first mid-flight.
--
-- So: queue single-workspace steps and fire them one at a time, each
-- only once the previous step's animation has had its full duration to
-- finish. Every individual hop is then identical in distance and time
-- to a lone press, so the speed never changes - multiple presses just
-- look like one continuous glide through the workspaces in between.
-- The first hop of a fresh chain fires immediately, so a single press
-- is exactly as snappy as before.
local WORKSPACE_ANIM_MS = 250 -- must match the "workspaces" leaf's speed*100
local workspaceQueue = 0
local workspaceChainRunning = false

local function stepWorkspaceChain()
	if workspaceQueue == 0 then
		workspaceChainRunning = false
		return
	end
	local step = workspaceQueue > 0 and 1 or -1
	workspaceQueue = workspaceQueue - step
	hl.dispatch(hl.dsp.focus({ workspace = step > 0 and "+1" or "-1" }))
	hl.timer(stepWorkspaceChain, { timeout = WORKSPACE_ANIM_MS, type = "oneshot" })
end

local function queueWorkspaceDelta(delta)
	workspaceQueue = workspaceQueue + delta
	if not workspaceChainRunning then
		workspaceChainRunning = true
		stepWorkspaceChain()
	end
end

-- j/k move within a column; at the top/bottom of the column, they fall
-- through to the workspace above/below instead (niri-style).
local function verticalFocus(delta)
	local win = hl.get_active_window()
	local col, idx = columnPosition(win)

	if col and ((delta < 0 and idx > 0) or (delta > 0 and idx < #col.windows - 1)) then
		hl.dispatch(hl.dsp.focus({ direction = delta < 0 and "up" or "down" }))
	else
		queueWorkspaceDelta(delta)
	end
end

-- Shift+j/k moves the window instead - not debounced, each press is its
-- own deliberate move rather than a scroll you'd mash through.
local function verticalMove(delta)
	local win = hl.get_active_window()
	local col, idx = columnPosition(win)

	if col and ((delta < 0 and idx > 0) or (delta > 0 and idx < #col.windows - 1)) then
		hl.dispatch(hl.dsp.window.move({ direction = delta < 0 and "up" or "down" }))
	else
		hl.dispatch(hl.dsp.window.move({ workspace = delta < 0 and "-1" or "+1" }))
	end
end

hl.bind(mod .. " + j", function() verticalFocus(1) end)
hl.bind(mod .. " + k", function() verticalFocus(-1) end)
hl.bind(mod .. " + SHIFT + j", function() verticalMove(1) end)
hl.bind(mod .. " + SHIFT + k", function() verticalMove(-1) end)

-- h/l move focus between columns.
hl.bind(mod .. " + h", hl.dsp.focus({ direction = "left" }))
hl.bind(mod .. " + l", hl.dsp.focus({ direction = "right" }))

-- Shift+h/l: consume the focused window into the column to the
-- left/right (stacking it on top), or if it's already stacked with
-- others, expel it out into its own column in that direction. Pressing
-- the same direction twice swaps it with whatever was already there.
hl.bind(mod .. " + SHIFT + h", hl.dsp.window.move({ direction = "left" }))
hl.bind(mod .. " + SHIFT + l", hl.dsp.window.move({ direction = "right" }))
