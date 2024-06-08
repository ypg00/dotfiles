#!/usr/bin/env bash

# Script to create symlinks to all dotfiles

CONFIG_DIR="$HOME/.config"
DOTFILES="$HOME/.dotfiles"

# Ensure .config directory exists
mkdir -p "$CONFIG_DIR"

create_symlink() {
  local src="$1"
  local dest="$2"

  echo "Symlinking $src to $dest"
  ln -sfv "$src" "$dest"
}

# .zshrc
create_symlink "$DOTFILES/zsh/.zshrc" "$HOME/.zshrc"

# nvim
create_symlink "$DOTFILES/nvim" "$CONFIG_DIR/nvim"

# karabiner
create_symlink "$DOTFILES/karabiner" "$CONFIG_DIR/karabiner"

# source "$HOME/.zshrc"
