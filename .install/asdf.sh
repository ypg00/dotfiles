#!/usr/bin/env bash

echo "===== ASDF ====="

DOTFILES_GLOBAL_VERSION="$HOME/dotfiles/asdf/.global-tool-versions"
SYMLINK_PATH="$HOME/.tool-versions"
mkdir -p $HOME/.asdf/plugins

source_asdf() {
    if [ -f "/opt/homebrew/opt/asdf/libexec/asdf.sh" ]; then
        . "/opt/homebrew/opt/asdf/libexec/asdf.sh"
    else
        echo "asdf is not installed or could not be found. Please install asdf first."
        exit 1
    fi
}

# Source asdf if not already available
if ! command -v asdf &> /dev/null; then
    source_asdf
fi

if [ ! -f "$DOTFILES_GLOBAL_VERSION" ]; then
    echo ".global-tool-versions file not found in dotfiles directory."
    exit 1
fi

# Create an array of all added plugins
if [ -n "$(ls -A $HOME/.asdf/plugins/ 2>/dev/null)" ]; then
    installed_plugins=($(ls -d $HOME/.asdf/plugins/* | xargs -n 1 basename))
else
    installed_plugins=()
fi

is_plugin_installed() {
    local plugin=$1
    for installed_plugin in "${installed_plugins[@]}"; do
        if [ "$installed_plugin" == "$plugin" ]; then
            return 0
        fi
    done
    return 1
}

while read -r line; do
    plugin=$(echo "$line" | awk '{print $1}')
    version=$(echo "$line" | awk '{print $2}')

    if ! is_plugin_installed "$plugin"; then
        echo "Adding $plugin"
        case $plugin in
            pipenv)
                # pipenv - needs a URL for installation
                pipenv_url="https://github.com/and-semakin/asdf-pipenv.git"
                asdf plugin add "$plugin" "$pipenv_url"
                ;;
            *)
                asdf plugin add "$plugin"
                ;;
        esac
    fi

    if asdf list "$plugin" 2>/dev/null | grep -q "$version"; then
        continue
    else
        echo "Installing $plugin version $version"
        asdf install "$plugin" "$version"
    fi

done < "$DOTFILES_GLOBAL_VERSION"

ln -sfv $DOTFILES_GLOBAL_VERSION $SYMLINK_PATH
asdf reshim

echo "===== asdf configuration complete ====="
