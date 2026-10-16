-- A lone tiled window floats itself to half the monitor's size, centered.
-- This is a static (one-time, on-open) effect, so manually resizing it
-- afterward sticks - but it also means the window stays floating if a
-- second window opens later, rather than re-tiling automatically.
hl.window_rule({
	match = { workspace = "w[t1]" },
	float = true,
	center = true,
	size = { "monitor_w * 0.5", "monitor_h * 0.5" },
})
