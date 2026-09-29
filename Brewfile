# Everything Homebrew installs. Apply with `brew bundle`,
# check for drift with `brew bundle check`, and see extras with `brew bundle cleanup`.
#
# Packages from third-party taps use their full tap/name and `trusted: true`;
# Homebrew refuses to load untrusted taps.

# Shell and editor
brew "gh"
brew "neovim"
brew "tree-sitter-cli" # nvim-treesitter compiles its parsers with it
brew "tmux"
brew "fzf"
brew "zoxide"
brew "ripgrep"
brew "fd"
brew "jq"
brew "yq"
brew "wget"
brew "shellcheck"
brew "yamllint"
brew "zsh-autosuggestions"
brew "zsh-syntax-highlighting"

# Languages (node comes from mise, python from uv)
brew "mise"
brew "uv"
brew "go"
cask "dotnet-sdk"

# AWS and Terraform (tfswitch installs whichever terraform version a repo pins)
brew "awscli"
cask "warrensbox/tap/tfswitch", trusted: true
brew "terraform-docs"

# Kubernetes
brew "kubernetes-cli"
brew "helm"
brew "k9s"
brew "flux"
brew "kind"

# Databases
brew "libpq", link: true # psql
brew "sqlcmd"

# Testing, security and CI
brew "k6"
brew "trivy"
brew "act"

# Used by bootstrap.sh to set up the Dock
brew "dockutil"

# Apps
cask "1password"
cask "nikitabobko/tap/aerospace", trusted: true
cask "docker-desktop"
cask "google-chrome"
cask "iterm2"
cask "visual-studio-code"

