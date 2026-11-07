#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="${OJUNY_ROOT:-$PWD}"
CONFIG="$REPO_ROOT/modules/07-system/01-configuration.nix"
HOST_MODULE="$REPO_ROOT/modules/07-system/00-host.nix"

state_version="26.11"
for arg in "$@"; do
  case "$arg" in
  --force) ;;
  --state-version=*) state_version="${arg#*=}" ;;
  *)
    echo "create-new-system: unknown argument: $arg" >&2
    exit 2
    ;;
  esac
done

read -rp "Hostname [ojuny]: " hostname
hostname="${hostname:-ojuny}"

if [ -f "$CONFIG" ]; then
  sed -i "s|^\( *\)networking\.hostName = .*;|\1networking.hostName = \"$hostname\";|" "$CONFIG"
  sed -i "s|^\( *\)system\.stateVersion = .*;|\1system.stateVersion = \"$state_version\";|" "$CONFIG"
  echo "create-new-system: set networking.hostName and system.stateVersion in $CONFIG"
else
  echo "create-new-system: $CONFIG not found, skipping hostname" >&2
fi

flake_uri="${OJUNY_FLAKE_URI:-git+https://github.com/OWNER/REPO?dir=HOST}"
clone_path="${OJUNY_CLONE_PATH:-repos/nix-flake}"

{
  cat <<EOF
{ self, inputs, ... }: {

  flake.nixosConfigurations.$hostname = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      self.modules.nixos.host-imports
      ({ lib, ... }: {
        services.simple-nix-update-gui.flakeUri = lib.mkDefault "$flake_uri";
        services.simple-nix-update-gui.clonePath = lib.mkDefault "$clone_path";
      })
    ];
  };

}
EOF
} >"$HOST_MODULE"

echo "create-new-system: wrote $HOST_MODULE (nixosConfigurations.$hostname)"
