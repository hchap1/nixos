-- Terminals start narrower than general apps (scrolling_width is the
-- per-window default column width - see appearance.lua's scrolling
-- config for the global default all other windows use).
hl.window_rule({
	match = { class = "com.mitchellh.ghostty" },
	scrolling_width = 0.25,
})

-- Floating dialogs/popups (file pickers, confirmation prompts, etc.) get
-- a small centered size instead of inheriting a tiled column's width.
-- This only fires for windows that open floating on their own - it won't
-- touch a tiled window you later float by hand.
hl.window_rule({
	match = { float = true },
	center = true,
	size = { "500", "400" },
})

-- slurp's overlay is a layer surface, so it inherits the "layers" animation
-- leaf (animations.lua, speed = 4 -> a 400ms fade-out). The process exiting
-- does not remove the layer; the fade does, 400ms later. screenshot.sh runs
-- grim ~20ms after slurp exits, which lands mid-fade and bakes slurp's dim
-- wash into the capture. Measured: the layer outlives the process by 405ms.
-- no_anim makes the surface go away with the process, which is what the
-- script already assumes happens.
hl.layer_rule({
	match = { namespace = "selection" },
	no_anim = true,
})
