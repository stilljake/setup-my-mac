# Setup My Mac

Bash script to set up a new Mac with the tools and settings I like to use. It will:

- Install Homebrew packages and apps from the [Brewfile](Brewfile)
- Install my [dotfiles](https://github.com/stilljake/dotfiles) and [Neovim config](https://github.com/stilljake/kickstart.nvim)
- Configure AeroSpace and iTerm2
- Set my macOS [preferences](macos.sh)
- Set up the Dock
- Install Claude Code

## Installation

```bash
# Install Apple's command line tools (includes git)
xcode-select --install

# Clone this repo and run the script
git clone https://github.com/stilljake/setup-my-mac.git ~/Development/setup-my-mac
~/Development/setup-my-mac/bootstrap.sh
```

Log out and back in afterwards for all the macOS settings to take effect.

## Keeping Homebrew in sync

The script only installs what's in the Brewfile; it never removes anything. To compare the Mac with the Brewfile:

```bash
brew bundle check            # anything in the Brewfile not installed?
brew bundle cleanup          # anything installed that isn't in the Brewfile?
brew bundle cleanup --force  # uninstall those extras
```

## iTerm2 settings

iTerm2 loads its settings from [`iterm2/`](iterm2). To save changes back to the repo, use iTerm2 → Settings → General → Settings → Save Now.

## Acknowledgements

Originally based on Jeff Geerling's Ansible playbook, [geerlingguy/mac-dev-playbook](https://github.com/geerlingguy/mac-dev-playbook).
