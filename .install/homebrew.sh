#!/usr/bin/env bash

echo "===== HOMEBREW ====="
brew update
brew upgrade

PACKAGES="$HOME/dotfiles/homebrew/packages"
TMP_BREWFILE="$HOME/dotfiles/homebrew/tmp_brewfile"

brew bundle dump --file="$TMP_BREWFILE"
installed_packages=($(grep -E '^(brew|cask) ' "$TMP_BREWFILE" | awk '{print $2}' | sed 's/"//g'))

required_packages=()
while IFS= read -r line; do
  required_packages+=("$line")
done < "$PACKAGES"

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

echo "===== Homebrew synchronization complete ====="
