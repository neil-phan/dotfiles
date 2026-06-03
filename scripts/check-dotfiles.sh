#!/usr/bin/env bash
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
# Shared package lists (config_pkgs, home_pkgs) — see scripts/packages.sh.
source "${root}/scripts/packages.sh"

echo "Checking stow targets..."

for pkg in "${config_pkgs[@]}"; do
    target="${HOME}/.config/${pkg}"
    if [[ ! -d "${target}" ]]; then
        echo "missing: ${target}"
        continue
    fi
    stow -n -d "${root}" -t "${target}" "${pkg}" >/tmp/stow_check.log 2>&1 || true
    if grep -q "WARNING! stowing ${pkg} would cause conflicts" /tmp/stow_check.log; then
        echo "conflict: ${pkg} -> ${target}"
    fi
done

# home_pkgs stow into $HOME; claude does too (handled specially by install.sh).
for pkg in "${home_pkgs[@]}" claude; do
    stow -n -d "${root}" -t "${HOME}" "${pkg}" >/tmp/stow_check.log 2>&1 || true
    if grep -q "WARNING! stowing ${pkg} would cause conflicts" /tmp/stow_check.log; then
        echo "conflict: ${pkg} -> ${HOME}"
    fi
done

echo "Check complete."
