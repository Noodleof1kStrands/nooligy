#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage: factory-reset [--template URL] [--dry-run] [--help]

Reset the template configuration while keeping the current user, their files,
the hostname, the state versions and the hardware configuration.

The default template source is the repository's origin remote. Use
--template to reset from a different fork or URL.
EOF
}

dry_run=0
template=""
while [ "$#" -gt 0 ]; do
  case "$1" in
  --template)
    template="${2:-}"
    [ -n "$template" ] || {
      echo "factory-reset: --template needs a value" >&2
      exit 2
    }
    shift
    ;;
  --dry-run) dry_run=1 ;;
  --help | -h)
    usage
    exit 0
    ;;
  *)
    echo "factory-reset: unknown argument: $1" >&2
    exit 2
    ;;
  esac
  shift
done

repo_root="${OJUNY_ROOT:-$(git rev-parse --show-toplevel 2>/dev/null || pwd)}"
host_file="$repo_root/modules/07-system/00-host.nix"
user_file="$repo_root/modules/01-users/01-user.nix"
config_file="$repo_root/modules/07-system/01-configuration.nix"
hardware_file="$repo_root/modules/07-system/00-hardware.nix"
facter_file="$repo_root/modules/07-system/facter.json"
quirks_file="$repo_root/modules/07-system/00-hardware-quirks.nix"

[ -f "$repo_root/flake.nix" ] || {
  echo "factory-reset: $repo_root is not the Ojuny repository" >&2
  exit 1
}
for required in "$host_file" "$user_file" "$config_file" "$hardware_file"; do
  [ -f "$required" ] || {
    echo "factory-reset: missing $required" >&2
    exit 1
  }
done

host="$(sed -n 's/.*nixosConfigurations\.\([A-Za-z0-9._-]*\) =.*/\1/p' "$host_file" | sed -n '1p')"
[ -n "$host" ] || {
  echo "factory-reset: could not read the host from $host_file" >&2
  exit 1
}

hostname="$(sed -n 's/^ *networking\.hostName = "\(.*\)";/\1/p' "$config_file" | sed -n '1p')"
hostname="${hostname:-ojuny}"
system_state_version="$(sed -n 's/^ *system\.stateVersion = "\([0-9][0-9.]*\)";/\1/p' "$config_file" | sed -n '1p')"
system_state_version="${system_state_version:-26.11}"

template="${template:-$(git -C "$repo_root" remote get-url origin 2>/dev/null || true)}"
[ -n "$template" ] || {
  echo "factory-reset: no origin remote; pass --template URL" >&2
  exit 1
}

echo "Factory reset"
echo "  repository:   $repo_root"
echo "  template:     $template"
echo "  host:         $host"
echo "  hostname:     $hostname"
echo "  system state: $system_state_version"
echo
echo "Kept:"
echo "  - $user_file"
echo "  - $host_file"
echo "  - $hardware_file"
[ -f "$facter_file" ] && echo "  - $facter_file"
[ -f "$quirks_file" ] && echo "  - $quirks_file"
echo "  - hostname and system state version"
echo "  - /home and all user files"
echo
echo "Reset:"
echo "  - every other file in the repository, including local configuration"
echo

if [ "$dry_run" -eq 1 ]; then
  echo "factory-reset: dry run, nothing changed"
  exit 0
fi

read -rp "Type RESET to continue: " answer
[ "$answer" = "RESET" ] || {
  echo "factory-reset: aborted" >&2
  exit 1
}

timestamp="$(date +%Y%m%d-%H%M%S)"
backup_dir="/var/lib/ojuny/factory-reset/$timestamp"
sudo install -d -m 0700 "$backup_dir"
sudo cp -a "$user_file" "$backup_dir/01-user.nix"
sudo cp -a "$host_file" "$backup_dir/00-host.nix"
sudo cp -a "$hardware_file" "$backup_dir/00-hardware.nix"
[ -f "$facter_file" ] && sudo cp -a "$facter_file" "$backup_dir/facter.json"
[ -f "$quirks_file" ] && sudo cp -a "$quirks_file" "$backup_dir/00-hardware-quirks.nix"
echo "factory-reset: backed up the kept files to $backup_dir"

tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

echo "==> cloning $template"
git clone --depth 1 "$template" "$tmp/template"

[ -f "$tmp/template/flake.nix" ] || {
  echo "factory-reset: the template has no flake.nix" >&2
  exit 1
}
[ -d "$tmp/template/modules" ] || {
  echo "factory-reset: the template has no modules directory" >&2
  exit 1
}

mkdir -p "$tmp/preserve/modules/01-users" "$tmp/preserve/modules/07-system"
cp -a "$user_file" "$tmp/preserve/modules/01-users/01-user.nix"
cp -a "$host_file" "$tmp/preserve/modules/07-system/00-host.nix"
cp -a "$hardware_file" "$tmp/preserve/modules/07-system/00-hardware.nix"
[ -f "$facter_file" ] && cp -a "$facter_file" "$tmp/preserve/modules/07-system/facter.json"
[ -f "$quirks_file" ] && cp -a "$quirks_file" "$tmp/preserve/modules/07-system/00-hardware-quirks.nix"

echo "==> replacing repository contents"
rsync -a --delete --exclude='.git' "$tmp/template/" "$repo_root/"

cp -a "$tmp/preserve/." "$repo_root/"

if grep -q 'system-ssh-test' "$user_file" &&
  [ -e "$repo_root/modules/07-system/_00-ssh-test.nix" ] &&
  [ ! -e "$repo_root/modules/07-system/00-ssh-test.nix" ]; then
  mv "$repo_root/modules/07-system/_00-ssh-test.nix" "$repo_root/modules/07-system/00-ssh-test.nix"
fi

sed -i "s|^\( *\)networking\.hostName = .*;|\1networking.hostName = \"$hostname\";|" "$config_file"
sed -i "s|^\( *\)system\.stateVersion = .*;|\1system.stateVersion = \"$system_state_version\";|" "$config_file"

if [ -d "$repo_root/.git" ]; then
  git -C "$repo_root" add -A
fi

echo
echo "==> nixos-rebuild boot --flake $repo_root#$host"
nixos-rebuild boot --flake "$repo_root#$host" --sudo

echo
read -rp "Reboot now? [y/N] " reboot
case "$reboot" in
[yY] | [yY][eE][sS]) sudo systemctl reboot ;;
*)
  echo "factory-reset: done. Reboot when ready."
  ;;
esac
