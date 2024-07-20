#!/usr/bin/env bash

# Script to create symlinks to all dotfiles

# NOTE:
# abbr: env var is set in .zshrc that points to dotfiles
# asdf: handled by asdf script in order to stay synced

echo "===== Symlinking dotfiles ====="
CONFIG_DIR="$HOME/.config"
DOTFILES="$HOME/dotfiles"

# Ensure .config directory exists
mkdir -p "$CONFIG_DIR"

create_symlink() {
  local src="$1"
  local dest="$2"
  if [ -e "$dest" ] || [ -L "$dest" ]; then
    rm -rf "$dest"
  fi
  ln -sf "$src" "$dest"
}

create_symlink "$DOTFILES/justfile" "$HOME/justfile"
create_symlink "$DOTFILES/karabiner" "$CONFIG_DIR/karabiner"
create_symlink "$DOTFILES/kitty" "$CONFIG_DIR/kitty"
create_symlink "$DOTFILES/nvim" "$CONFIG_DIR/nvim"
create_symlink "$DOTFILES/pypoetry" "$CONFIG_DIR/pypoetry"
create_symlink "$DOTFILES/zsh/.zshrc" "$HOME/.zshrc"


# ===== .gitconfig =====
cp "$DOTFILES/git/gitconfig-global" "$HOME/.gitconfig"

# Append contents of gitconfig-github to global .gitconfig
if [ -f "$DOTFILES/git/gitconfig-github" ]; then
  cat "$DOTFILES/git/gitconfig-github" >> "$HOME/.gitconfig"
else
  echo "File $DOTFILES/git/gitconfig-github not found. Skipping append to $HOME/.gitconfig"
fi

# Check if directory exists before copying and appending
if [ -d "$HOME/workspace/dare" ]; then
  # Append contents of gitconfig-bitbucket to .gitconfig in dare
  if [ -f "$DOTFILES/git/gitconfig-bitbucket" ]; then
    cp "$DOTFILES/git/gitconfig-global" "$HOME/workspace/dare/.gitconfig"
    cat "$DOTFILES/git/gitconfig-bitbucket" >> "$HOME/workspace/dare/.gitconfig"
  else
    echo "File $DOTFILES/git/gitconfig-bitbucket not found. Skipping append to $HOME/workspace/dare/.gitconfig"
  fi
fi

echo "===== Finished symlinking to dotfiles ====="
