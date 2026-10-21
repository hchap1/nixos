#!/usr/bin/env bash
set -euo pipefail

# Deliberately minimal: slurp draws the selection box, exits, *then* grim
# grabs the real (un-overlaid) frame. grimblast's freeze-frame trick (take
# a screenshot first, show that as the backdrop, unfreeze after) was
# causing visible flicker and sometimes leaking the selection box itself
# into the capture - this skips all of that.
mode="$1" # "copy" or "save"

geometry="$(slurp)" || exit 0 # empty on Esc/right-click cancel

dir="$HOME/Pictures/Screenshots"
mkdir -p "$dir"
file="$dir/screenshot-$(date +%Y-%m-%d_%H-%M-%S).png"

grim -g "$geometry" "$file"

if [ "$mode" = copy ]; then
	wl-copy < "$file"
	rm -f "$file"
	notify-send -a Screenshot "Screenshot copied" "Copied to clipboard"
else
	wl-copy < "$file"
	notify-send -a Screenshot "Screenshot saved" "$file"
fi
