#!/usr/bin/env bash

sudo -v # Ask for admin password upfront

echo "----- MACOS SETTINGS -----"
osascript -e 'tell application "System Preferences" to quit' # close System Preferences panes to prevent overriding

echo "Keyboard: increase key repeat rates"
echo "...current InitialKeyRepeat: $(defaults read -g InitialKeyRepeat)"
defaults write -g InitialKeyRepeat -int 15
echo "...updated InitialKeyRepeat: $(defaults read -g InitialKeyRepeat)"
echo "...current KeyRepeat: $(defaults read -g KeyRepeat)"
defaults write -g KeyRepeat -int 1
echo "...updated KeyRepeat: $(defaults read -g KeyRepeat)"

echo "Trackpad: enable tap to click for this user and for the login screen"
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
echo "Trackpad: map bottom right corner to right-click"
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadCornerSecondaryClick -int 2
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRightClick -bool true
defaults -currentHost write NSGlobalDomain com.apple.trackpad.trackpadCornerClickBehavior -int 1
defaults -currentHost write NSGlobalDomain com.apple.trackpad.enableSecondaryClick -bool true

echo "Finder: permit quitting"
defaults write com.apple.finder QuitMenuItem -bool true; killall Finder
echo "Finder: set Documents as the default location for new windows"
defaults write com.apple.finder NewWindowTarget -string "PfLo"
defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/Documents/"
echo "Finder: show all filename extensions"
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
echo "Finder: use list view in all windows by default"
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv" # view modes: `icnv`, `clmv`, `glyv`
echo "Finder: disable the warning before emptying the Trash"
defaults write com.apple.finder WarnOnEmptyTrash -bool false

echo "Dock: wipe all (default) app icons from the Dock"
defaults write com.apple.dock persistent-apps -array
echo "Dock: show only open applications"
defaults write com.apple.dock static-only -bool true
echo "Dock: don’t animate opening applications"
defaults write com.apple.dock launchanim -bool false
echo "Dock: don’t automatically rearrange Spaces based on most recent use"
defaults write com.apple.dock mru-spaces -bool false
echo "Dock: remove the auto-hiding delay"
defaults write com.apple.dock autohide-delay -float 0
echo "Dock: remove the animation when hiding/showing"
defaults write com.apple.dock autohide-time-modifier -float 0
echo "Dock: automatically hide and show"
defaults write com.apple.dock autohide -bool true
echo "Dock: don’t show recent applications"
defaults write com.apple.dock show-recents -bool false

echo "Screensaver: start after 5 minutes of inactivity"
defaults -currentHost write com.apple.screensaver idleTime $((5 * 60))
echo "Screensaver: require password immediately after"
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0
screenshot_location=$HOME/Pictures/Screenshots/
echo "Screenshots: save to $screenshot_location"
mkdir -p $screenshot_location
defaults write com.apple.screencapture location -string $screenshot_location
echo "Screenshots: save in PNG format" # other options: BMP, GIF, JPG, PDF, TIFF
defaults write com.apple.screencapture type -string "png"

# May be a bad idea, if the screen is dead but computer boots, e.g.
# echo "System: disable the sound effects on boot"
# sudo nvram SystemAudioVolume=" "
echo "System: disable Resume system-wide"
defaults write com.apple.systempreferences NSQuitAlwaysKeepsWindows -bool false
echo "System: set Hot Corners"
# Possible values:
#  0: no-op
#  2: Mission Control
#  3: Show application windows
#  4: Desktop
#  5: Start screen saver
#  6: Disable screen saver
#  7: Dashboard
# 10: Put display to sleep
# 11: Launchpad
# 12: Notification Center
# 13: Lock Screen
echo "Top left screen corner → Null"
defaults write com.apple.dock wvous-tl-corner -int 0
defaults write com.apple.dock wvous-tl-modifier -int 0
echo "Top right screen corner → Mission Control"
defaults write com.apple.dock wvous-tr-corner -int 2
defaults write com.apple.dock wvous-tr-modifier -int 0
echo "Bottom left screen corner → Desktop"
defaults write com.apple.dock wvous-bl-corner -int 4
defaults write com.apple.dock wvous-bl-modifier -int 0
echo "Bottom right screen corner → Start screen saver"
defaults write com.apple.dock wvous-br-corner -int 5
defaults write com.apple.dock wvous-br-modifier -int 0
echo "===== Some macOS setting require a restart to take effect ====="

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
