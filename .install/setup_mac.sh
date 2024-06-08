#!/usr/bin/env bash

sudo -v # Ask for admin password upfront





echo "----- HOMEBREW -----"
# Install homebrew and packages
# curl install homebrew
brew_casks=("alfred" "bitwarden" "firefox" "iterm2" "karabiner-elements" "microsoft-teams" "slack" "spotify")
brew_formulae=("asdf" "bat" "docker" "eza" "httpie" "ipython" "lazygit" "olets/tap/zsh-abbr" "openssh" "ripgrep")

for cask in "${brew_casks[@]}"; do
    brew install "$cask"
done

for formula in "${brew_formulae[@]}"; do
    brew install "$formula"
done

# Add Hombrew's zsh shell to allowable shells list
sudo sh -c 'echo /opt/homebrew/bin/zsh >> /etc/shells'
# Change the default login shell to Homebrew managed zsh
chsh -s /opt/homebrew/bin/zsh


echo "----- DIRECTORY TREE -----"
# Build out the directory tree for the workspace
cd $HOME
mkdir -p workspace/dare
mkdir -p workspace/_dailies
mkdir -p workspace/_notes
mkdir -p workspace/_scripts

echo "----- ASDF -----"
# Install various clis and languages with asdf
plugins=("argo" "awscli" "eksctl" "kubectl" "neovim" "nodejs" "python")

for plugin in "${plugins[@]}"; do
    echo "Installing latest version of $plugin"
    asdf plugin add "$plugin"
    asdf install "$plugin" latest
    asdf global "$plugin" latest
done