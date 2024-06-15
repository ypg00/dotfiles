#!/usr/bin/env bash

echo "----- ASDF ------"
echo "Installing asdf plugins and setting versions"

DOTFILES_GLOBAL_VERSION="$HOME/.dotfiles/asdf/.global-tool-versions"
SYMLINK_PATH="$HOME/.tool-versions"

# Ensure asdf is sourced
source_asdf() {
    if [ -f "/opt/homebrew/opt/asdf/libexec/asdf.sh" ]; then
        . "/opt/homebrew/opt/asdf/libexec/asdf.sh"
    else
        echo "asdf is not installed or could not be found. Please install asdf first."
        exit 1
    fi
}
if ! command -v asdf &> /dev/null; then
    source_asdf
fi

# Check if .tool-versions file exists
if [ ! -f "$DOTFILES_GLOBAL_VERSION" ]; then
    echo ".global-tool-versions file not found in .dotfiles directory."
    exit 1
fi

# Remove root global .tool-versions file or symlink to avoid conflicts
rm $SYMLINK_PATH || true

# Install asdf plugins and set versions
while read -r line; do
    plugin=$(echo "$line" | awk '{print $1}')
    version=$(echo "$line" | awk '{print $2}')

    # Check if plugin is already installed
    if ! asdf plugin list | grep -q "^$plugin$"; then
        echo "Installing $plugin plugin"
        asdf plugin add "$plugin"
    else
        echo "$plugin plugin is already installed"
    fi

    echo "Setting $plugin version to $version"
    asdf install "$plugin" "$version"
    asdf global "$plugin" "$version"
done < "$DOTFILES_GLOBAL_VERSION"

# Symlink to .dotfiles version, override original
ln -sfv $DOTFILES_GLOBAL_VERSION $SYMLINK_PATH
# Reshim all to ensure everything is in place
asdf reshim

echo "===== asdf plugins installed and versions set ====="
