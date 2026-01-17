#!/bin/bash

set -e

cd "$(dirname "${BASH_SOURCE[0]}")"

# Check if stow is installed
if ! command -v stow &> /dev/null; then
    echo "Error: stow is not installed"
    exit 1
fi

# Configs that go to ~/.config/<package>/
for pkg in nvim fish foot fuzzel gtk-3.0 gtk-4.0 hypr quickshell wlogout; do
    mkdir -p ~/.config/"$pkg"
    stow -t ~/.config/"$pkg" "$pkg"
done

# Configs that go to ~/
stow -t ~ tmux

echo "Dotfiles installed!"
