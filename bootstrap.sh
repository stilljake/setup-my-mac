#!/usr/bin/env bash
# Set up this Mac: Homebrew packages, dotfiles, app config, macOS settings, Dock.
# Safe to re-run: every step skips or overwrites what's already there.
set -euo pipefail

REPO="$(cd "$(dirname "$0")" && pwd)"
DOTFILES="$HOME/Development/dotfiles"
NVIM_CONFIG="$HOME/.config/nvim"

step() { printf '\n==> %s\n' "$*"; }

# Clone over HTTPS (no SSH keys on a fresh Mac yet) but push over SSH.
clone() {
  local repo="$1" dest="$2"
  [ -d "$dest" ] && return
  git clone "https://github.com/$repo.git" "$dest"
  git -C "$dest" remote set-url --push origin "git@github.com:$repo.git"
}

step "Homebrew"
if [ ! -x /opt/homebrew/bin/brew ]; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
eval "$(/opt/homebrew/bin/brew shellenv)"
brew bundle --file "$REPO/Brewfile"

step "Dotfiles"
clone stilljake/dotfiles "$DOTFILES"
"$DOTFILES/install.sh"

step "Neovim config"
clone stilljake/kickstart.nvim "$NVIM_CONFIG"

step "AeroSpace config"
ln -sfn "$REPO/aerospace/aerospace.toml" "$HOME/.aerospace.toml"

step "iTerm2 preferences (loaded from $REPO/iterm2)"
defaults write com.googlecode.iterm2 PrefsCustomFolder -string "$REPO/iterm2"
defaults write com.googlecode.iterm2 LoadPrefsFromCustomFolder -bool true

step "Claude Code"
if [ ! -x "$HOME/.local/bin/claude" ]; then
  curl -fsSL https://claude.ai/install.sh | bash
fi

step "mise tools (global node LTS)"
mise install

step "macOS settings"
"$REPO/macos.sh"

step "Dock"
dockutil --remove all --no-restart
for app in \
  /System/Applications/Apps.app \
  /Applications/Safari.app \
  "/System/Applications/System Settings.app" \
  /Applications/iTerm.app; do
  dockutil --add "$app" --no-restart
done
dockutil --add "$HOME/Downloads" --no-restart
killall Dock 2>/dev/null || true # may still be restarting after macos.sh

step "Done. Log out and back in for every setting to take effect."
