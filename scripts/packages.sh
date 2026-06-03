#!/usr/bin/env bash
# Single source of truth for stow package lists, shared by install.sh and
# scripts/check-dotfiles.sh so the two can never drift apart.
#
# The `claude` package is intentionally NOT listed here: install.sh handles it
# specially (it pre-creates ~/.claude/{skills,agents,commands} so stow makes
# per-item symlinks instead of one folded dir symlink). check-dotfiles.sh
# checks it as a one-off.

# Stowed into ~/.config/<pkg>
config_pkgs=(nvim fish hypr quickshell environment.d xdg-desktop-portal fontconfig ghostty)

# Stowed into $HOME
home_pkgs=(tmux starship)
