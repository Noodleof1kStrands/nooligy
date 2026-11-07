#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage: handover [--dry-run] [--help]

Regenerate the user account, build the next generation and clear /home before
the next boot. The system configuration and hostname are kept.

Run from the Ojuny repository, or set OJUNY_ROOT to its path.
EOF
}

dry_run=0
while [ "$#" -gt 0 ]; do
  case "$1" in
  --dry-run) dry_run=1 ;;
  --help | -h)
    usage
    exit 0
    ;;
  *)
    echo "handover: unknown argument: $1" >&2
    exit 2
    ;;
  esac
  shift
done

repo_root="${OJUNY_ROOT:-$(git rev-parse --show-toplevel 2>/dev/null || pwd)}"
host_file="$repo_root/modules/07-system/00-host.nix"
user_file="$repo_root/modules/01-users/01-user.nix"

[ -f "$repo_root/flake.nix" ] || {
  echo "handover: $repo_root is not the Ojuny repository" >&2
  exit 1
}
[ -f "$host_file" ] || {
  echo "handover: missing $host_file" >&2
  exit 1
}
[ -f "$user_file" ] || {
  echo "handover: missing $user_file" >&2
  exit 1
}

host="$(sed -n 's/.*nixosConfigurations\.\([A-Za-z0-9._-]*\) =.*/\1/p' "$host_file" | sed -n '1p')"
[ -n "$host" ] || {
  echo "handover: could not read the host from $host_file" >&2
  exit 1
}

home_state_version="$(sed -n 's/.*home\.stateVersion = "\([0-9][0-9.]*\)".*/\1/p' "$user_file" | sed -n '1p')"
home_state_version="${home_state_version:-26.11}"

[ -d /home ] || {
  echo "handover: /home is not a directory" >&2
  exit 1
}
[ ! -L /home ] || {
  echo "handover: /home is a symlink; refusing to clear it" >&2
  exit 1
}

mapfile -t home_entries < <(sudo find /home -mindepth 1 -maxdepth 1 ! -name lost+found -printf '%f\n' | sort)

echo "Machine handover"
echo "  repository: $repo_root"
echo "  host:       $host"
echo "  user file:  $user_file"
echo "  home state: $home_state_version"
echo
echo "The following home directories will be removed after the build succeeds:"
if [ "${#home_entries[@]}" -eq 0 ]; then
  echo "  (none)"
else
  printf '  /home/%s\n' "${home_entries[@]}"
fi
if [[ "$repo_root" == /home/* ]]; then
  echo
  echo "WARNING: the repository is inside /home. It will be removed with the old user."
  echo "Clone the repository again after the handover."
fi
echo

if [ "$dry_run" -eq 1 ]; then
  echo "handover: dry run, nothing changed"
  exit 0
fi

read -rp "Type HANDOVER to continue: " answer
[ "$answer" = "HANDOVER" ] || {
  echo "handover: aborted" >&2
  exit 1
}

timestamp="$(date +%Y%m%d-%H%M%S)"
backup_dir="/var/lib/ojuny/handover/$timestamp"
sudo install -d -m 0700 "$backup_dir"
sudo cp -a "$user_file" "$backup_dir/01-user.nix"
echo "handover: backed up the current user file to $backup_dir"

export OJUNY_ROOT="$repo_root"
generate-user --force --state-version "$home_state_version"

if [ -d "$repo_root/.git" ]; then
  git -C "$repo_root" add -A
fi

echo
echo "==> nixos-rebuild boot --flake $repo_root#$host"
nixos-rebuild boot --flake "$repo_root#$host" --sudo

echo
echo "==> clearing /home"
sudo find /home -mindepth 1 -maxdepth 1 ! -name lost+found -exec rm -rf -- {} +

echo
read -rp "Reboot now? [y/N] " reboot
case "$reboot" in
[yY] | [yY][eE][sS]) sudo systemctl reboot ;;
*)
  echo "handover: done. Reboot when ready."
  ;;
esac
