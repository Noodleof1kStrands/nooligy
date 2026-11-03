#!/usr/bin/env bash
set -euo pipefail

REPO_URL="https://github.com/ojuny-project/ojuny-template"
default_clone_dir="${OJUNY_CLONE_DIR:-$HOME/repos/nix-flake}"
branch="${OJUNY_BRANCH:-}"

while [ "$#" -gt 0 ]; do
  case "$1" in
  --branch | -b)
    branch="${2:-}"
    shift 2
    ;;
  *)
    echo "setup: unknown argument: $1" >&2
    exit 2
    ;;
  esac
done

printf '\033[2J\033[H'

cat <<EOF
============================================================
  Ojuny installer
============================================================

This installs Ojuny from your own fork of the template.

If you have not made a fork yet:

  1. open  $REPO_URL
  2. click "Fork" and create your own copy
  3. copy the URL of YOUR fork, for example
       git@github.com:your-name/ojuny-template.git
     or
       https://github.com/your-name/ojuny-template.git

EOF

read -rp "Git URL of your fork: " fork_url
if [ -z "${fork_url:-}" ]; then
  echo "setup: no URL given, aborting" >&2
  exit 1
fi

read -rp "Location to clone into [$default_clone_dir]: " clone_answer
CLONE_DIR="${clone_answer:-$default_clone_dir}"

if [ -e "$CLONE_DIR" ]; then
  echo "setup: $CLONE_DIR already exists, aborting (remove it or set OJUNY_CLONE_DIR)" >&2
  exit 1
fi

echo
mkdir -p "$(dirname "$CLONE_DIR")"
if [ -n "$branch" ]; then
  echo "==> cloning $fork_url (branch $branch)"
  git clone --branch "$branch" "$fork_url" "$CLONE_DIR"
else
  echo "==> cloning $fork_url"
  git clone "$fork_url" "$CLONE_DIR"
fi

export OJUNY_ROOT="$CLONE_DIR"
cd "$CLONE_DIR"

echo "==> repository cloned, press any key to continue"
read -rn 1

echo
echo "==> generate-hw: hardware module"
generate-hw --force

echo
echo "==> generate-user: account module"
generate-user --force

case "$fork_url" in
http://* | https://*) OJUNY_FLAKE_URI="git+$fork_url" ;;
*) OJUNY_FLAKE_URI="$fork_url" ;;
esac
export OJUNY_FLAKE_URI
export OJUNY_CLONE_PATH="$CLONE_DIR"

echo
echo "==> create-new-system: host wiring"
create-new-system --force

echo
echo "==> git add (so the flake sees the generated files)"
git add -A

host="$(sed -n 's/.*nixosConfigurations\.\([A-Za-z0-9._-]*\) =.*/\1/p' \
  "$CLONE_DIR/modules/07-system/00-host.nix" | sed -n '1p')"

echo
echo "Your Ojuny configuration is ready in $CLONE_DIR"
if [ -z "$host" ]; then
  echo "setup: could not read the hostname from 00-host.nix, skipping the rebuild prompt" >&2
  exit 0
fi

echo "The next step builds the system and makes it the boot default."
echo

nix_settings_gui_dir="$HOME/.config/nix-settings-gui"
mkdir -p "$nix_settings_gui_dir"
terminal_shell="$(sed -n 's/.*shell = pkgs\.\([A-Za-z0-9_-]*\);.*/\1/p' \
  "$CLONE_DIR/modules/01-users/01-user.nix" | sed -n '1p')"
terminal_shell="${terminal_shell:-zsh}"
cat >"$nix_settings_gui_dir/config.json" <<EOF
{
  "flake_path": "$CLONE_DIR",
  "terminal_command": "ghostty -e $terminal_shell -c",
  "rebuild_command": "sudo echo \"starting rebuild\"; sudo nixos-rebuild boot --flake $CLONE_DIR#$host |& nom",
  "reload_dms_on_rebuild": true
}
EOF
echo "==> wrote $nix_settings_gui_dir/config.json"
echo

PS3="What do you want to do now? "
select action in "rebuild and reboot" "rebuild (do not reboot)" "do not rebuild or reboot"; do
  case "$action" in
  "rebuild and reboot" | "rebuild (do not reboot)")
    break
    ;;
  "do not rebuild or reboot")
    echo "setup: done, nothing built"
    exit 0
    ;;
  esac
done

echo
echo "==> pre-building compiled targets one at a time (avoids concurrent OOM)"
for target in nix-settings-gui nix-regedit nix-shell-gui simple-nix-update-gui simple-nix-update-gui-daemon mango dux dms-greeter nix-cache-discovery nix-cleaner; do
  echo "==> building $target"
  nix build --no-link --max-jobs 1 --print-build-logs "$CLONE_DIR#$target"
done

echo
echo "==> nixos-rebuild boot --flake $CLONE_DIR#$host"
nixos-rebuild boot --flake "$CLONE_DIR#$host" --sudo

if [ "$action" = "rebuild and reboot" ]; then
  echo
  echo "==> rebooting into the new system"
  sudo systemctl reboot
fi

echo
echo "setup: done. Reboot later with 'sudo systemctl reboot' to use the new system."
