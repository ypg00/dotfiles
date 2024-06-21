#!/usr/bin/env bash

sudo -v # Ask for admin password upfront

DOTFILES=$HOME/dotfiles
SCRIPTS=$DOTFILES/.install

# Setup macos settings
chmod u+x $SCRIPTS/macos.sh
$SCRIPTS/macos.sh

echo "----- Xcode Command Line Tools (homebrew dependancy) -----"
# Check if the Xcode Command Line Tools are already installed
if ! xcode-select -p > /dev/null 2>&1; then
  # Trigger the installation of Xcode Command Line Tools
  xcode-select --install
  echo "Waiting for Xcode Command Line Tools to be installed..."
  # Wait until the tools are installed
  until xcode-select -p > /dev/null 2>&1; do
    sleep 5
  done
else
  echo "Xcode Command Line Tools are already installed."
fi

# Installing homebrew
NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

echo "Configuring Homebrew..."
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> "$HOME/.zshrc"
eval "$(/opt/homebrew/bin/brew shellenv)"
brew install firefox
echo "Installed Firefox, opening now ..."
open -a "Firefox"

chmod u+x $SCRIPTS/setup_ssh.sh
$SCRIPTS/setup_ssh.sh

# Homebrew package install
chmod u+x $SCRIPTS/homebrew.sh
$SCRIPTS/homebrew.sh

# Symlink dotfiles
chmod u+x $SCRIPTS/symlink.sh
$SCRIPTS/symlink.sh

# Syncing to asdf global version
chmod u+x $SCRIPTS/asdf.sh
$SCRIPTS/asdf.sh

echo "----- DIRECTORY TREE -----"
# Build out the directory tree for the workspace
cd $HOME
mkdir -p workspace/_dailies
mkdir -p workspace/_notes
mkdir -p workspace/_scripts

echo "----- Mac setup complete -----"
