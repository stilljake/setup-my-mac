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

## Testing

[`test/vm-test.sh`](test/vm-test.sh) runs the script on a clean macOS VM using [Tart](https://tart.run). It runs `bootstrap.sh` twice, to check it's safe to re-run, then checks the result:

```bash
# Install Tart (its Homebrew formula doesn't load on Homebrew 7 yet)
curl -fsSL https://github.com/cirruslabs/tart/releases/latest/download/tart.tar.gz | tar -xz -C ~/Applications tart.app
ln -sf ~/Applications/tart.app/Contents/MacOS/tart ~/.local/bin/tart

test/vm-test.sh    # add --keep to leave the VM running and look around
```

The first run downloads the macOS image (about 25 GB). Later runs use the cached copy. The VM opens in a window: click Install when it asks for the Command Line Tools, as you would on a new Mac. It tests your local copy of this repo, but pulls dotfiles and the Neovim config from GitHub, so push changes there first.

## Acknowledgements

Originally based on Jeff Geerling's Ansible playbook, [geerlingguy/mac-dev-playbook](https://github.com/geerlingguy/mac-dev-playbook).
