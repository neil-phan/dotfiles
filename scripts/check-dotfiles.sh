#!/usr/bin/env bash
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
config_pkgs=(nvim fish fuzzel hypr quickshell environment.d xdg-desktop-portal fontconfig ghostty)
home_pkgs=(tmux starship)

echo "Checking stow targets..."

for pkg in "${config_pkgs[@]}"; do
    target="${HOME}/.config/${pkg}"
    if [[ ! -d "${target}" ]]; then
        echo "missing: ${target}"
        continue
    fi
    stow -n -d "${root}" -t "${target}" "${pkg}" >/tmp/stow_check.log 2>&1 || true
    if rg -q "WARNING! stowing ${pkg} would cause conflicts" /tmp/stow_check.log; then
        echo "conflict: ${pkg} -> ${target}"
    fi
done

for pkg in "${home_pkgs[@]}"; do
    stow -n -d "${root}" -t "${HOME}" "${pkg}" >/tmp/stow_check.log 2>&1 || true
    if rg -q "WARNING! stowing ${pkg} would cause conflicts" /tmp/stow_check.log; then
        echo "conflict: ${pkg} -> ${HOME}"
    fi
done

echo "Check complete."
