#!/usr/bin/env bash

# Script to create symlinks to all dotfiles

# NOTE:
# abbr: env var is set in .zshrc that points to dotfiles
# asdf: handled by asdf script in order to stay synced

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

create_symlink "$DOTFILES/git/.global-gitconfig" "$HOME/.gitconfig"
create_symlink "$DOTFILES/karabiner" "$CONFIG_DIR/karabiner"
create_symlink "$DOTFILES/nvim" "$CONFIG_DIR/nvim"
create_symlink "$DOTFILES/zsh/.zshrc" "$HOME/.zshrc"
