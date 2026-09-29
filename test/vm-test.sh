#!/usr/bin/env bash
# Test bootstrap.sh on a clean macOS VM (Tart): run it twice to check it's safe to re-run, then check the result.
# Usage: test/vm-test.sh [--keep]   (--keep leaves the VM running so you can look around)
set -euo pipefail

IMAGE="ghcr.io/cirruslabs/macos-golden-gate-vanilla:27.0" # clean macOS 27 (bump the tag for newer macOS), user admin/admin, SSH on
VM="setup-my-mac-test"
REPO="$(cd "$(dirname "$0")/.." && pwd)"

# Vanilla images have no guest agent, so use SSH with the password supplied via SSH_ASKPASS
ASKPASS="$(mktemp)"
printf '#!/bin/sh\necho admin\n' > "$ASKPASS" && chmod +x "$ASKPASS"
trap 'rm -f "$ASKPASS"' EXIT
vssh() {
  SSH_ASKPASS="$ASKPASS" SSH_ASKPASS_REQUIRE=force ssh -o StrictHostKeyChecking=no \
    -o UserKnownHostsFile=/dev/null -o LogLevel=ERROR -o PreferredAuthentications=password "admin@$IP" "$@"
}

tart stop "$VM" 2>/dev/null || true
tart delete "$VM" 2>/dev/null || true
tart clone "$IMAGE" "$VM" # uses the local cache after the first download
tart run "$VM" --dir="repo:$REPO:ro" >/dev/null 2>&1 &
IP="$(tart ip "$VM" --wait 180)"
until vssh true </dev/null 2>/dev/null; do sleep 3; done

# macOS only installs the Command Line Tools through a dialog, just like on a new Mac
if ! vssh 'xcode-select -p' </dev/null >/dev/null 2>&1; then
  vssh 'xcode-select --install' </dev/null || true
  echo "==> Click Install in the VM window to install the Command Line Tools"
  until vssh 'xcode-select -p' </dev/null >/dev/null 2>&1; do sleep 10; done
fi

vssh 'mkdir -p ~/Development && cp -R "/Volumes/My Shared Files/repo" ~/Development/setup-my-mac' </dev/null
for run in 1 2; do
  echo "==> bootstrap.sh run $run"
  vssh 'NONINTERACTIVE=1 ~/Development/setup-my-mac/bootstrap.sh' </dev/null
done

echo "==> Checks"
vssh 'bash -s' <<'EOF'
set -euo pipefail
eval "$(/opt/homebrew/bin/brew shellenv)"
brew bundle check --file ~/Development/setup-my-mac/Brewfile
for f in .zshrc .tmux.conf .gitconfig .claude/settings.json .aerospace.toml; do
  [ -L ~/"$f" ] || { echo "not linked: $f"; exit 1; }
done
zsh -lic 'for c in nvim tmux mise uv node kubectl aws claude; do command -v $c >/dev/null || { echo "missing: $c"; exit 1; }; done' 2>/dev/null
dockutil --list | cut -f1
EOF

if [ "${1:-}" = "--keep" ]; then
  echo "==> Passed. VM '$VM' left running (ssh admin@$IP, password admin)"
else
  tart stop "$VM" && tart delete "$VM"
  echo "==> Passed"
fi
