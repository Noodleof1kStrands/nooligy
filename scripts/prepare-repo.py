#!/usr/bin/env python3
import argparse
import json
import os
import re
import shutil
import sys


def nix_string(value):
    text = str(value).replace("${", "''${")
    return json.dumps(text, ensure_ascii=False)


def replace_once(text, pattern, replacement, label, required=False):
    result, count = re.subn(pattern, replacement, text, count=1)
    if count != 1:
        if required:
            raise RuntimeError("could not set {}".format(label))
        print("prepare-repo: could not set {}".format(label), file=sys.stderr)
    return result


def user_module(username, fullname, hashed_password, shell, version):
    return """/* @menu
   displayname = "Users";
   icon = "avatar-default-symbolic";
   order = 10;
   description = "User Accounts";
   category = "01-Users";
*/

{{ self, inputs, ... }}: {{

  flake.modules.nixos.users = {{ pkgs, ... }}: {{

    imports = [ inputs.home-manager.nixosModules.home-manager ];

    config = {{
      /* @option widget = "users"; label = "Accounts"; homeManager = true; */
      users.users = {{
        {username} = {{
          isNormalUser = true;
          uid = 1000;
          description = {fullname};
          extraGroups = [ "networkmanager" "wheel" "video" "input" ];
          hashedPassword = {hashed_password};
          openssh.authorizedKeys.keys = [ ];
          shell = pkgs.{shell};
        }};
      }};

      home-manager.users = {{
        {username} = {{
          home.stateVersion = "{version}";
        }};
      }};
    }};

  }};

}}
""".format(
        username=username,
        fullname=nix_string(fullname),
        hashed_password=nix_string(hashed_password),
        shell=shell,
        version=version,
    )


def host_module(hostname, runtime_clone):
    return """{{ self, inputs, ... }}: {{

  flake.nixosConfigurations.{hostname} = inputs.nixpkgs.lib.nixosSystem {{
    system = "x86_64-linux";
    modules = [
      self.modules.nixos.host-imports
      ({{ lib, ... }}: {{
        services.simple-nix-update-gui.flakeUri = lib.mkDefault {flake_uri};
        services.simple-nix-update-gui.clonePath = lib.mkDefault {clone_path};
      }})
    ];
  }};

}}
""".format(
        hostname=nix_string(hostname),
        flake_uri=nix_string("path:" + runtime_clone),
        clone_path=nix_string(runtime_clone),
    )


def copy_template(template, root, force):
    if not os.path.isdir(template):
        raise RuntimeError("template not found: {}".format(template))

    template_real = os.path.realpath(template)
    root_real = os.path.realpath(root)
    if root_real == template_real or root_real.startswith(template_real + os.sep):
        raise RuntimeError("refusing to copy the template into itself")

    if os.path.exists(root) and os.listdir(root) and not force:
        raise RuntimeError("{} is not empty (pass --force)".format(root))

    os.makedirs(root, exist_ok=True)
    for entry in os.listdir(template):
        if entry == ".git":
            continue
        source = os.path.join(template, entry)
        target = os.path.join(root, entry)
        if os.path.isdir(source) and not os.path.islink(source):
            shutil.copytree(source, target, dirs_exist_ok=True, symlinks=True)
        else:
            shutil.copy2(source, target, follow_symlinks=False)

    for current, directories, files in os.walk(root):
        for name in directories + files:
            path = os.path.join(current, name)
            if not os.path.islink(path):
                os.chmod(path, os.stat(path).st_mode | 0o200)


def configure(args, root):
    configuration_path = os.path.join(root, "modules/07-system/01-configuration.nix")

    with open(configuration_path) as handle:
        configuration = handle.read()

    configuration = replace_once(
        configuration,
        r'networking\.hostName = "[^"]*";',
        "networking.hostName = {hostname};".format(
            hostname=nix_string(args.hostname)
        ),
        "networking.hostName",
        required=True,
    )
    configuration = replace_once(
        configuration,
        r'system\.stateVersion = "[^"]*";',
        "system.stateVersion = {version};".format(
            version=nix_string(args.state_version)
        ),
        "system.stateVersion",
        required=True,
    )

    if args.timezone:
        configuration = replace_once(
            configuration,
            r'time\.timeZone = "[^"]*";',
            "time.timeZone = {zone};".format(zone=nix_string(args.timezone)),
            "time.timeZone",
        )
    if args.locale:
        configuration = replace_once(
            configuration,
            r'i18n\.defaultLocale = "[^"]*";',
            "i18n.defaultLocale = {locale};".format(locale=nix_string(args.locale)),
            "i18n.defaultLocale",
        )
    if args.keymap:
        configuration = replace_once(
            configuration,
            r'console\.keyMap = "[^"]*";',
            "console.keyMap = {keymap};".format(keymap=nix_string(args.keymap)),
            "console.keyMap",
        )

    with open(configuration_path, "w") as handle:
        handle.write(configuration)

    runtime_clone = os.path.join("/home", args.username, args.clone_relative)

    with open(os.path.join(root, "modules/01-users/01-user.nix"), "w") as handle:
        handle.write(
            user_module(
                args.username,
                args.fullname,
                args.hashed_password,
                args.shell,
                args.state_version,
            )
        )

    with open(os.path.join(root, "modules/07-system/00-host.nix"), "w") as handle:
        handle.write(host_module(args.hostname, runtime_clone))


def main():
    parser = argparse.ArgumentParser(
        description="Prepare a fresh ojuny-template repository for installation."
    )
    parser.add_argument("--root", required=True, help="Target repository path.")
    parser.add_argument("--template", required=True, help="Template source path.")
    parser.add_argument("--username", required=True)
    parser.add_argument("--fullname", default=None)
    parser.add_argument("--hashed-password", default="!")
    parser.add_argument("--shell", choices=["zsh", "bash", "fish"], default="zsh")
    parser.add_argument("--hostname", required=True)
    parser.add_argument("--timezone", default=None)
    parser.add_argument("--locale", default=None)
    parser.add_argument("--keymap", default=None)
    parser.add_argument("--state-version", default="26.11")
    parser.add_argument("--clone-relative", default="repos/nix-flake")
    parser.add_argument("--force", action="store_true")
    args = parser.parse_args()

    if not re.fullmatch(r"[a-z_][a-z0-9_-]*", args.username):
        parser.error("invalid username: {}".format(args.username))
    if not re.fullmatch(r"[A-Za-z0-9]([A-Za-z0-9-]*[A-Za-z0-9])?", args.hostname):
        parser.error("invalid hostname: {}".format(args.hostname))
    if args.fullname is None:
        args.fullname = args.username

    try:
        copy_template(args.template, args.root, args.force)
        configure(args, args.root)
    except Exception as error:
        print("prepare-repo: {}".format(error), file=sys.stderr)
        return 1

    print("prepare-repo: prepared {}".format(args.root))
    return 0


if __name__ == "__main__":
    sys.exit(main())
