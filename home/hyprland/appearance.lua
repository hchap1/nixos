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
		border_size = 3,
		col = {
			active_border = "rgba(" .. border .. "ff)",
		},
	},
})
