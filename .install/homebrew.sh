#!/usr/bin/env bash

echo "===== HOMEBREW ====="
brew update
brew upgrade

BREWFILE="$HOME/dotfiles/homebrew/Brewfile"
TMP_BREWFILE=$(mktemp)
brew bundle dump --file="$TMP_BREWFILE"

installed_packages_str=$(grep -E '^(brew|cask) ' "$TMP_BREWFILE" | awk '{print $2}')
required_packages_str=$(grep -E '^(brew|cask) ' "$BREWFILE" | awk '{print $2}')

# Convert strs to arrays
IFS=$'\n' read -rd '' -a installed_packages <<<"$installed_packages_str"
IFS=$'\n' read -rd '' -a required_packages <<<"$required_packages_str"

packages_to_install=()
for package in "${required_packages[@]}"; do
  if [[ ! " ${installed_packages[*]} " =~ " $package " ]]; then
    packages_to_install+=("$package")
  fi
done

if [ ${#packages_to_install[@]} -ne 0 ]; then
  for package in "${packages_to_install[@]}"; do
    brew install "$package"
  done
fi

brew cleanup
rm -f "$TMP_BREWFILE"

echo "===== Homebrew synchronization complete ======"
