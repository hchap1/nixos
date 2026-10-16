-- Auto-detect: safe default for the ultrawide until you pin an exact mode
-- with `hyprctl monitors` (resolution/144Hz aren't guessed here).
hl.monitor({
	output = "",
	mode = "preferred",
	position = "auto",
	scale = "auto",
})
