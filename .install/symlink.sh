#!/usr/bin/env bash

# Script to create symlinks to all dotfiles

echo "----- Symlinking .dotfiles -----"
cd $HOME || exit
CONFIG_DIR="$HOME/.config"
DOTFILES="$HOME/.dotfiles"
mkdir -p "$CONFIG_DIR" # Ensure .config directory exists

create_symlink() {
  local src="$1"
  local dest="$2"
  echo "Symlinking $src to $dest"
  ln -sfv "$src" "$dest"
}

create_symlink "$DOTFILES/asdf/.global-tool-versions" "$HOME/.tool-versions"
create_symlink "$DOTFILES/karabiner" "$CONFIG_DIR/karabiner"
create_symlink "$DOTFILES/nvim" "$CONFIG_DIR/nvim"
create_symlink "$DOTFILES/zsh/.zshrc" "$HOME/.zshrc"
