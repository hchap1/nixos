-- Reads the active noctalia theme from its state file (the same file
-- `noctalia msg color-scheme-set` persists to - see theme-switch.sh) and
-- sets the focused-window border color to match.
local state_file = os.getenv("HOME") .. "/.local/state/noctalia/settings.toml"

local function activeTheme()
	local f = io.open(state_file, "r")
	if not f then return "Catppuccin" end
	for line in f:lines() do
		local name = line:match('^builtin%s*=%s*"([^"]+)"')
		if name then
			f:close()
			return name
		end
	end
	f:close()
	return "Catppuccin"
end

local accent = {
	Catppuccin = "cba6f7", -- mauve
	Gruvbox    = "fe8019", -- orange
}

local border = accent[activeTheme()] or accent.Catppuccin

hl.config({
	general = {
		layout = "scrolling",
		border_size = 3,
		col = {
			active_border = "rgba(" .. border .. "ff)",
		},

		gaps_in = 0,
		gaps_out = 0
	},
	-- Niri-style infinite-scrolling columns: new columns appear to the
	-- right, don't wrap at the first/last column, and focus only scrolls
	-- the view the minimum amount needed to bring the focused column
	-- fully on screen (1 = "fit") rather than recentering on every focus
	-- change (0 = "center"). SUPER+C (binds.lua) centers on demand.
	scrolling = {
		direction = "right",
		column_width = 0.5,
		wrap_focus = 0,
		wrap_swapcol = 0,
		focus_fit_method = 1,
	},
})
