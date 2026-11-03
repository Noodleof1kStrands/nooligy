#!/usr/bin/env bash
set -euo pipefail

template="${OJUNY_TEMPLATE_SOURCE:-}"
flake=""
host=""
target=""
ssh_user=""
remote_build=0
dry_run=0

usage() {
  cat <<'EOF'
Usage: remote-setup [options]

Push an Ojuny configuration to a machine that already runs NixOS or Ojuny.
The target must have SSH access and the deploy-rs node is taken from the
template flake.

Options:
  --flake URL|PATH      Template or fork with nixosConfigurations and deploy
                        nodes (default: the running template)
  --host NAME           nixosConfigurations name (default: the only host)
  --target USER@HOST    SSH target (default: root@NAME)
  --ssh-user USER       SSH user override
  --remote-build        Build on the target instead of the local machine
  --dry-run             Print the deploy command without running it
  -h, --help            Show this help
EOF
}

while [ "$#" -gt 0 ]; do
  case "$1" in
    --flake)
      flake="${2:-}"
      shift 2
      ;;
    --host)
      host="${2:-}"
      shift 2
      ;;
    --target)
      target="${2:-}"
      shift 2
      ;;
    --ssh-user)
      ssh_user="${2:-}"
      shift 2
      ;;
    --remote-build)
      remote_build=1
      shift
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
      echo "remote-setup: unknown argument: $1" >&2
      usage >&2
      exit 2
      ;;
  esac
done

flake="${flake:-$template}"
if [ -z "$flake" ]; then
  echo "remote-setup: no flake given and no template source available" >&2
  exit 2
fi

work_dir="$(mktemp -d)"
trap 'rm -rf "$work_dir"' EXIT

case "$flake" in
  http://* | https://* | git+* | ssh://* | git@*)
    echo "cloning $flake"
    git clone --depth 1 "$flake" "$work_dir/template"
    flake="$work_dir/template"
    flake_ref="path:$flake"
    ;;
  /*)
    flake_ref="path:$flake"
    ;;
  *)
    flake_ref="$flake"
    ;;
esac

if [ ! -f "$flake/flake.nix" ]; then
  echo "remote-setup: no flake.nix at $flake" >&2
  exit 1
fi

if [ -z "$host" ]; then
  host="$(nix eval --raw "$flake_ref#nixosConfigurations" \
    --apply 'x: builtins.head (builtins.attrNames x)' 2>/dev/null || true)"
  if [ -z "$host" ]; then
    echo "remote-setup: the flake has no nixosConfigurations; run setup first or pass --host" >&2
    exit 1
  fi
fi

if [ -z "$target" ]; then
  target="root@$host"
fi

target_user="${target%@*}"
target_host="${target#*@}"
if [ "$target_user" = "$target" ]; then
  target_user="root"
  target_host="$target"
fi
if [ -n "$ssh_user" ]; then
  target_user="$ssh_user"
fi

if ! nix eval --raw "$flake_ref#deploy.nodes.$host.hostname" >/dev/null 2>&1; then
  echo "remote-setup: $flake does not declare deploy.nodes.$host" >&2
  exit 1
fi

deploy_args=(
  "$flake_ref#$host"
  --hostname "$target_host"
  --ssh-user "$target_user"
)
if [ "$remote_build" -eq 1 ]; then
  deploy_args+=(--remote-build)
fi

if [ "$dry_run" -eq 1 ]; then
  printf 'deploy'
  printf ' %q' "${deploy_args[@]}"
  printf '\n'
  exit 0
fi

exec "$OJUNY_DEPLOY_RS" "${deploy_args[@]}"
