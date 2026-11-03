#!/usr/bin/env bash
set -euo pipefail

target=""
flake=""
host=""
disk=""
firmware="efi"
template="${OJUNY_TEMPLATE_SOURCE:-}"
build_on="remote"
prepare=0
dry_run=0
password=""
ssh_keys=()

usage() {
  cat <<'EOF'
Usage: remote-install [options]

Install Ojuny on a machine that is not running NixOS yet. The script prepares a
repository with a disko layout when needed, then runs nixos-anywhere.

Options:
  --target USER@HOST    SSH target (required)
  --flake DIR           Prepared repository (default: prepare a temporary one)
  --host NAME           nixosConfigurations name (default: the only host)
  --disk DEVICE         Target disk for a prepared repository
  --firmware efi|bios   Target firmware (default: efi)
  --template URL|PATH   Template for a prepared repository
  --prepare             Prepare --flake in place before installing
  --password PASS       Account password for a prepared repository
  --ssh-key KEY         SSH public key, repeatable
  --build-on local|remote
                        nixos-anywhere build location (default: remote)
  --dry-run             Print the install command without running it
  -h, --help            Show this help
EOF
}

while [ "$#" -gt 0 ]; do
  case "$1" in
    --target)
      target="${2:-}"
      shift 2
      ;;
    --flake)
      flake="${2:-}"
      shift 2
      ;;
    --host)
      host="${2:-}"
      shift 2
      ;;
    --disk)
      disk="${2:-}"
      shift 2
      ;;
    --firmware)
      firmware="${2:-}"
      shift 2
      ;;
    --template)
      template="${2:-}"
      shift 2
      ;;
    --prepare)
      prepare=1
      shift
      ;;
    --password)
      password="${2:-}"
      shift 2
      ;;
    --ssh-key)
      ssh_keys+=("${2:-}")
      shift 2
      ;;
    --build-on)
      build_on="${2:-}"
      shift 2
      ;;
    --dry-run)
      dry_run=1
      shift
      ;;
    -h | --help)
      usage
      exit 0
      ;;
    *)
      echo "remote-install: unknown argument: $1" >&2
      usage >&2
      exit 2
      ;;
  esac
done

if [ -z "$target" ]; then
  echo "remote-install: --target is required" >&2
  exit 2
fi
case "$build_on" in
  local | remote) ;;
  *)
    echo "remote-install: --build-on must be local or remote" >&2
    exit 2
    ;;
esac

work_dir="$(mktemp -d)"
trap 'rm -rf "$work_dir"' EXIT

prepare_repository() {
  local destination="$1"
  if [ -z "$template" ]; then
    echo "remote-install: no template source available" >&2
    exit 2
  fi
  if [ -z "$disk" ]; then
    echo "remote-install: --disk is required to prepare a repository" >&2
    exit 2
  fi

  prepare_args=(
    --template "$template"
    --root "$destination"
    --hostname "${host:-ojuny}"
    --disk "$disk"
    --firmware "$firmware"
  )
  if [ -n "$password" ]; then
    prepare_args+=(--password "$password")
  fi
  for key in "${ssh_keys[@]}"; do
    prepare_args+=(--ssh-key "$key")
  done

  nix run "path:$OJUNY_TEMPLATE_SOURCE#prepare-remote-repository" -- "${prepare_args[@]}"
}

if [ -z "$flake" ]; then
  flake="$work_dir/repository"
  prepare_repository "$flake"
elif [ "$prepare" -eq 1 ]; then
  prepare_repository "$flake"
fi

flake_ref="path:$flake"
if [ ! -f "$flake/flake.nix" ]; then
  echo "remote-install: no flake.nix at $flake" >&2
  exit 1
fi

if [ -z "$host" ]; then
  host="$(nix eval --raw "$flake_ref#nixosConfigurations" \
    --apply 'x: builtins.head (builtins.attrNames x)' 2>/dev/null || true)"
  if [ -z "$host" ]; then
    echo "remote-install: the flake has no nixosConfigurations; pass --host" >&2
    exit 1
  fi
fi

install_args=(
  --flake "$flake_ref#$host"
  --target-host "$target"
  --build-on "$build_on"
)

if [ "$dry_run" -eq 1 ]; then
  printf 'nixos-anywhere'
  printf ' %q' "${install_args[@]}"
  printf '\n'
  exit 0
fi

exec "$OJUNY_NIXOS_ANYWHERE" "${install_args[@]}"
