#!/usr/bin/env bash
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
packages_file="${root}/packages.txt"

mapfile -t repo_pkgs < <(awk '
  BEGIN { section="repo" }
  /^#/ {
    if ($0 ~ /AUR packages/) section="aur"
    else if ($0 ~ /Repo packages/) section="repo"
    next
  }
  NF && section=="repo" { print $1 }
' "${packages_file}")

mapfile -t aur_pkgs < <(awk '
  BEGIN { section="repo" }
  /^#/ {
    if ($0 ~ /AUR packages/) section="aur"
    else if ($0 ~ /Repo packages/) section="repo"
    next
  }
  NF && section=="aur" { print $1 }
' "${packages_file}")

if command -v pacman >/dev/null; then
    if ((${#repo_pkgs[@]})); then
        sudo pacman -S --needed "${repo_pkgs[@]}"
    fi
else
    echo "pacman not found"
fi

aur_helper=""
if command -v yay >/dev/null; then
    aur_helper="yay"
elif command -v paru >/dev/null; then
    aur_helper="paru"
fi

if [[ -n "${aur_helper}" ]]; then
    if ((${#aur_pkgs[@]})); then
        "${aur_helper}" -S --needed "${aur_pkgs[@]}"
    fi
else
    if ((${#aur_pkgs[@]})); then
        echo "No AUR helper found (yay/paru)"
    fi
fi
