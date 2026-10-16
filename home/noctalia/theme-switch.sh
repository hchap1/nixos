#!/usr/bin/env bash
set -euo pipefail

config="$HOME/.config/noctalia/config.toml"
wallpapers="$HOME/Pictures/wallpapers"
nvim_state="$HOME/.cache/nvim/noctalia-theme"

current="$(grep -oP '(?<=^builtin = ")[^"]+' "$config" || true)"

if [ "$current" = "Catppuccin" ]; then
	target=Gruvbox
	wallpaper="$wallpapers/gruvbox.jpg"
	rgb_color=fe8019
	nvim_colorscheme=gruvbox
else
	target=Catppuccin
	wallpaper="$wallpapers/catppuccin.jpg"
	rgb_color=cba6f7
	nvim_colorscheme=catppuccin-mocha
fi

noctalia msg color-scheme-set builtin "$target"
noctalia msg theme-mode-set dark

# Falls back to whatever wallpaper is already set if the file isn't there.
[ -f "$wallpaper" ] && noctalia msg wallpaper-set "$wallpaper"

command -v openrgb >/dev/null 2>&1 && openrgb --mode static --color "$rgb_color" || true

mkdir -p "$(dirname "$nvim_state")"
echo "$nvim_colorscheme" > "$nvim_state"
pkill -SIGUSR1 nvim 2>/dev/null || true
