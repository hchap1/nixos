#!/usr/bin/env bash
set -euo pipefail

# `noctalia msg color-scheme-set` persists here, in the state dir - not in
# config.toml, which stays static. Reading config.toml for "current theme"
# is why this used to always compute the same target (bug, now fixed).
config="$HOME/.local/state/noctalia/settings.toml"
wallpapers="$HOME/Pictures/wallpapers"
nvim_state="$HOME/.cache/nvim/noctalia-theme"
discord_quickcss="$HOME/.config/vesktop/settings/quickCss.css"

current="$(grep -oP '(?<=^builtin = ")[^"]+' "$config" || true)"

if [ "$current" = "Catppuccin" ]; then
	target=Gruvbox
	wallpaper="$wallpapers/gruvbox.jpg"
	rgb_color=fe8019
	nvim_colorscheme=gruvbox
	discord_theme_url="https://raw.githubusercontent.com/shvedes/discord-gruvbox/main/gruvbox-dark.theme.css"
	# Catppuccin ships no actual gruvbox scheme; frappe is the warmest/
	# least-blue of its dark flavors, closest approximation available.
	spicetify_scheme=frappe
else
	target=Catppuccin
	wallpaper="$wallpapers/catppuccin.jpg"
	rgb_color=cba6f7
	nvim_colorscheme=catppuccin-mocha
	discord_theme_url="https://catppuccin.github.io/discord/dist/catppuccin-mocha.theme.css"
	spicetify_scheme=mocha
fi

noctalia msg color-scheme-set builtin "$target"
noctalia msg theme-mode-set dark

# Falls back to whatever wallpaper is already set if the file isn't there.
[ -f "$wallpaper" ] && noctalia msg wallpaper-set "$wallpaper"

# Backgrounded: openrgb has been observed to hang/crash talking to some
# devices on this board, which would otherwise block everything below
# (including the border-color reload) for as long as it takes to time out.
#
# The ASUS Aura USB device's two "Addressable RGB Header" zones (the case
# fans) default to 0 LEDs configured until sized, so color/mode commands
# silently no-op on them - only the mainboard's own 2 fixed LEDs responded
# without this. 16 is a guess (adjust if your fans have a different LED
# count per header); re-sizing to the same value is a no-op if already set.
#
# Every cold `openrgb ...` invocation re-scans I2C/HID/DRAM from scratch
# (~5-6s); that's why this used to take so much longer than everything
# else here. openrgb.nix runs a persistent `openrgb --server` that's
# already done that scan, so --client calls against it just ask the
# already-detected devices to update (~1s). Falls back to the slow path
# if the server isn't up for some reason, rather than silently doing
# nothing. `--client` itself hangs (not fails) when nothing's listening,
# so check the port's actually open first.
if command -v openrgb >/dev/null 2>&1; then
	(
		if timeout 1 bash -c "echo >/dev/tcp/127.0.0.1/6742" 2>/dev/null; then
			openrgb_cmd=(openrgb --client 127.0.0.1:6742)
		else
			openrgb_cmd=(openrgb)
		fi
		"${openrgb_cmd[@]}" --device "ASUS" --zone 1 --size 16 --zone 2 --size 16 >/dev/null 2>&1
		"${openrgb_cmd[@]}" --mode direct --color "$rgb_color" --brightness 100 >/dev/null 2>&1
	) &
fi

mkdir -p "$(dirname "$nvim_state")"
echo "$nvim_colorscheme" > "$nvim_state"
pkill -SIGUSR1 nvim 2>/dev/null || true

# quickCss.css is a plain file nixcord leaves for live editing (unlike
# settings.json, which it writes as a read-only nix-store symlink), so
# this survives until the next time this script runs - Vencord picks up
# @import changes without needing Discord restarted.
if [ -d "$(dirname "$discord_quickcss")" ]; then
	echo "@import url(\"$discord_theme_url\");" > "$discord_quickcss"
fi

# Backgrounded since spicetify apply touches Spotify's installed files
# and can take a moment. Only flips the color scheme within the already
# nix-installed catppuccin theme - if Spotify's open, it won't visually
# update until you restart it (spicetify's own limitation, not fixable
# from here).
command -v spicetify >/dev/null 2>&1 && (
	spicetify config color_scheme "$spicetify_scheme" >/dev/null 2>&1
	spicetify apply >/dev/null 2>&1
) &

# appearance.lua reads the theme file once at config-load time to pick
# the border accent color, so it needs a reload to pick up the switch.
hyprctl reload config-only 2>/dev/null || true
