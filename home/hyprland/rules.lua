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
