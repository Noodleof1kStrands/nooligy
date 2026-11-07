#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="${OJUNY_ROOT:-$PWD}"
OUT="$REPO_ROOT/modules/01-users/01-user.nix"
STATE_VERSION="26.11"

force=0
while [ "$#" -gt 0 ]; do
  case "$1" in
  --force) force=1 ;;
  --state-version)
    STATE_VERSION="${2:?--state-version needs a value}"
    shift
    ;;
  *)
    echo "generate-user: unknown argument: $1" >&2
    exit 2
    ;;
  esac
  shift
done

if [ -e "$OUT" ] && [ "$force" -ne 1 ]; then
  echo "generate-user: refusing to overwrite $OUT (pass --force)" >&2
  exit 1
fi

read -rp "Username [user]: " username
username="${username:-user}"
read -rp "Description (full name) [Primary account]: " description
description="${description:-Primary account}"
read -rp "Extra groups [networkmanager wheel video input]: " groups
groups="${groups:-networkmanager wheel video input}"
read -rp "Login shell [zsh]: " shell
shell="${shell:-zsh}"

read -rsp "Password (empty to leave locked): " password
echo

hashed="!"
if [ -n "$password" ]; then
  if command -v mkpasswd >/dev/null 2>&1; then
    hashed="$(mkpasswd -m yescrypt "$password" 2>/dev/null || mkpasswd -m sha-512 "$password")"
  else
    echo "generate-user: mkpasswd not found" >&2
    exit 1
  fi
fi

read -ra group_names <<<"$groups"
group_list=""
for g in "${group_names[@]}"; do
  group_list+="\"$g\" "
done
group_list="${group_list% }"

key_list=""
while true; do
  read -rp "SSH public key (empty to finish): " key
  [ -z "$key" ] && break
  key_list+="      \"$key\""$'\n'
done
if [ -z "$key_list" ]; then
  keys_block="[ ]"
else
  keys_block="$(printf '[\n%s    ]' "$key_list")"
fi

ssh_test_import=""
if [ "$username" = "den" ]; then
  ssh_test_import=" self.modules.nixos.system-ssh-test"
  if [ -e "$REPO_ROOT/modules/07-system/_00-ssh-test.nix" ]; then
    mv "$REPO_ROOT/modules/07-system/_00-ssh-test.nix" "$REPO_ROOT/modules/07-system/00-ssh-test.nix"
  fi
fi

{
  cat <<EOF
/* @menu
   displayname = "Users";
   icon = "avatar-default-symbolic";
   order = 10;
   description = "User Accounts";
   category = "01-Users";
*/

{ self, inputs, ... }: {

  flake.modules.nixos.users = { pkgs, ... }: {

    imports = [ inputs.home-manager.nixosModules.home-manager$ssh_test_import ];

    config = {
      /* @option widget = "users"; label = "Accounts"; homeManager = true; */
      users.users = {
        $username = {
          isNormalUser = true;
          uid = 1000;
          description = "$description";
          extraGroups = [ $group_list ];
          hashedPassword = "$hashed";
          openssh.authorizedKeys.keys = $keys_block;
          shell = pkgs.$shell;
        };
      };

      home-manager.users = {
        $username = {
          home.stateVersion = "$STATE_VERSION";
        };
      };
    };

  };

}
EOF
} >"$OUT"

echo "generate-user: wrote $OUT"
