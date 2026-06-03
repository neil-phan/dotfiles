#!/bin/bash

set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")/.."

if ! command -v stow &> /dev/null; then
    echo "Error: stow is not installed"
    exit 1
fi

# Package lists (config_pkgs, home_pkgs) live in scripts/packages.sh so this
# script and scripts/check-dotfiles.sh share one definition and can't drift.
source "${PWD}/scripts/packages.sh"

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

for pkg in "${home_pkgs[@]}"; do
    stow --restow -t "${HOME}" "${pkg}"
done

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

# monitors.conf / workspaces.conf are intentionally NOT written here. They stay
# stow-managed symlinks; monitors.conf delegates (source=) to the per-machine
# file ~/.config/hypr/hyprland/monitors.conf that nwg-displays writes. Copying a
# template over the stowed symlink wrote *through* it, corrupting the tracked
# repo file and breaking the display (stale monitor name) — so that was removed.

echo "Dotfiles installed!"
