#!/bin/bash

set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")"

if ! command -v stow &> /dev/null; then
    echo "Error: stow is not installed"
    exit 1
fi

config_pkgs=(nvim fish hypr quickshell environment.d xdg-desktop-portal fontconfig ghostty)

for pkg in "${config_pkgs[@]}"; do
    mkdir -p "${HOME}/.config/${pkg}"
    # Pre-create subdirs that need file-level (not directory-level) symlinks
    if [[ "${pkg}" == "hypr" ]]; then
        for subdir in hyprlock hyprland; do
            [[ -L "${HOME}/.config/hypr/${subdir}" ]] && unlink "${HOME}/.config/hypr/${subdir}"
            mkdir -p "${HOME}/.config/hypr/${subdir}"
        done
    fi
    stow --restow -t "${HOME}/.config/${pkg}" "${pkg}"
done

stow --restow -t "${HOME}" tmux
stow --restow -t "${HOME}" starship

# Claude Code skills/agents/commands — pre-create real dirs so stow makes
# per-item symlinks (not a single folded dir symlink), letting repo-managed
# and local items coexist.
mkdir -p "${HOME}/.claude/skills" "${HOME}/.claude/agents" "${HOME}/.claude/commands"
stow --restow -t "${HOME}" claude

colors_dst="${HOME}/.config/hypr/hyprlock/colors.conf"
[[ -L "${colors_dst}" ]] && unlink "${colors_dst}"
sed "s|__HOME__|${HOME}|g" "${PWD}/hypr/hyprlock/colors.conf" > "${colors_dst}"

gpu_dst="${HOME}/.config/hypr/hyprland/gpu.conf"
if grep -qi nvidia <<< "$(lspci)"; then
    cat > "${gpu_dst}" <<'EOF'
env = __GLX_VENDOR_LIBRARY_NAME,nvidia
env = LIBVA_DRIVER_NAME,nvidia
env = NVD_BACKEND,direct
EOF
else
    : > "${gpu_dst}"
fi

scale_dst="${HOME}/.config/hypr/hyprland/scale.conf"
[[ -L "${scale_dst}" ]] && unlink "${scale_dst}"
if [[ -f "${PWD}/templates/scale.conf.local" ]]; then
    cp "${PWD}/templates/scale.conf.local" "${scale_dst}"
else
    cp "${PWD}/hypr/hyprland/scale.conf" "${scale_dst}"
fi

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
