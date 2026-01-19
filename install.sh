#!/bin/bash

set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")"

if ! command -v stow &> /dev/null; then
    echo "Error: stow is not installed"
    exit 1
fi

config_pkgs=(nvim fish fuzzel hypr quickshell environment.d xdg-desktop-portal fontconfig kitty)

for pkg in "${config_pkgs[@]}"; do
    mkdir -p "${HOME}/.config/${pkg}"
    stow --restow -t "${HOME}/.config/${pkg}" "${pkg}"
done

stow --restow -t "${HOME}" tmux
stow --restow -t "${HOME}" starship

fg_dir="${HOME}/.config/floating-garden"
fg_template="${PWD}/floating-garden/config.json"
mkdir -p "${fg_dir}"
sed "s|__HOME__|${HOME}|g" "${fg_template}" > "${fg_dir}/config.json"

hypr_dir="${HOME}/.config/hypr"
mkdir -p "${hypr_dir}"
if [[ -f "${PWD}/templates/monitors.conf.local" ]]; then
    cp -f "${PWD}/templates/monitors.conf.local" "${hypr_dir}/monitors.conf"
fi
if [[ -f "${PWD}/templates/workspaces.conf.local" ]]; then
    cp -f "${PWD}/templates/workspaces.conf.local" "${hypr_dir}/workspaces.conf"
fi

echo "Dotfiles installed!"
