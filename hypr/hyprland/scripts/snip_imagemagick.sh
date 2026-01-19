#!/usr/bin/env bash
set -euo pipefail

region="$(slurp)"
# If slurp was cancelled, exit quietly
[[ -z "$region" ]] && exit 0

# Capture region, normalize via ImageMagick, copy to clipboard
# Using magick ensures consistent PNG output
grim -g "$region" - | magick - - | wl-copy --type image/png
