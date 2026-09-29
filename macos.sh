#!/usr/bin/env bash
# macOS preferences. Safe to re-run; some settings need a logout to take effect.
#
# To find the key for a setting:
#   defaults read > /tmp/before; <change the setting>; defaults read > /tmp/after
#   diff /tmp/before /tmp/after
#
# Originally based on Jeff Geerling's mac-dev-playbook .osx script.
set -euo pipefail

###############################################################################
# General UI/UX                                                               #
###############################################################################

# Dark mode
defaults write NSGlobalDomain AppleInterfaceStyle -string Dark

# Expand save panel by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true

# Save to disk (not to iCloud) by default
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

# Disable smart quotes and dashes (annoying when typing code)
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

###############################################################################
# Trackpad                                                                    #
###############################################################################

# Light click (haptic feedback)
defaults write com.apple.AppleMultitouchTrackpad FirstClickThreshold -int 0
defaults write com.apple.AppleMultitouchTrackpad SecondClickThreshold -int 0

# Bottom-right corner click = right-click
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRightClick -bool true
defaults write com.apple.AppleMultitouchTrackpad TrackpadRightClick -bool true
defaults write com.apple.AppleMultitouchTrackpad TrackpadCornerSecondaryClick -int 2
defaults write NSGlobalDomain ContextMenuGesture -int 1

# Tracking speed
defaults write NSGlobalDomain com.apple.trackpad.scaling -float 1.5

# No Mission Control / App Exposé swipe gestures (AeroSpace handles windows)
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerVertSwipeGesture -int 0
defaults write com.apple.AppleMultitouchTrackpad TrackpadFourFingerVertSwipeGesture -int 0
defaults write com.apple.dock showMissionControlGestureEnabled -bool false

###############################################################################
# Screenshots                                                                 #
###############################################################################

defaults write com.apple.screencapture location -string "$HOME/Downloads"
defaults write com.apple.screencapture type -string png
defaults write com.apple.screencapture disable-shadow -bool true

###############################################################################
# Finder                                                                      #
###############################################################################

# New windows open in the home folder
defaults write com.apple.finder NewWindowTarget -string PfLo
defaults write com.apple.finder NewWindowTargetPath -string "file://$HOME/"

# Search the current folder by default
defaults write com.apple.finder FXDefaultSearchScope -string SCcf

# List view by default (icnv = icon, clmv = column, glyv = gallery)
defaults write com.apple.finder FXPreferredViewStyle -string Nlsv

# Don't create .DS_Store files on network volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

# Show ~/Library
chflags nohidden ~/Library

###############################################################################
# Dock (apps in the Dock are set in bootstrap.sh)                             #
###############################################################################

defaults write com.apple.dock orientation -string left
defaults write com.apple.dock tilesize -int 45
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock show-recents -bool false

###############################################################################
# Restart affected apps                                                       #
###############################################################################

for app in Dock Finder SystemUIServer; do
  killall "$app" >/dev/null 2>&1 || true
done
