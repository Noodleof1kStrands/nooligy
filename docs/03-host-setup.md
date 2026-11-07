# 03 - Host setup

Spec for the setup script that turns the template into a working config for a
given machine. It generates `hardware.nix` and `user.nix` and wires a host into
the flake.

## 1. Goals

- A forked template becomes bootable with minimal manual editing.
- All machine-specific and personal data is produced by the script, never
  committed by hand.
- The generated `user.nix` is an ordinary `.nix` module with `@menu` /
  `@option` comments, so it shows up in the settings GUI. The generated
  `hardware.nix` has no `@menu` header and is never a menu (D5, D6a).

## 2. What the script generates

1. `hardware.nix` - filesystems, swap, kernel modules, CPU microcode, host
   platform. Generated from `nixos-generate-config --show-hardware-config`, or
   copied from `/etc/nixos/hardware-configuration.nix` when already on NixOS.
   The install path also writes `facter.json` from `nixos-facter`; the
   `regenerate-hardware` script writes `00-hardware-quirks.nix` with the
   selected `nixos-hardware` profile. These generated files are not templated
   (D13a).
2. `user.nix` - the primary account and home-manager home, templated then
   filled by the script. The generated Users page can add more accounts and
   their home-manager entries. Prompts for:
   - username (default `user`, D17)
   - description / full name
   - groups (default `networkmanager`, `wheel`, D15a)
   - shell (default zsh, D15a)
   - password (hashed via `mkpasswd -m yescrypt` or `-m sha-512`)
   - optional SSH authorized keys (paste, repeatable)
   - `home.stateVersion` only; `system.stateVersion` is written once and never
     exposed or prompted (D15a)
   - the temporary `system-ssh-test` module is imported only when the
     username is `den`
3. Host wiring - the single host imports the pages it uses plus the generated
   files, and `flake.nix` registers `nixosConfigurations.<hostname>`. All
   system-specific settings live in the system directory; making a second
   system means replicating and editing that directory (D13a).

## 3. Prompt flow

1. Clear the screen and print instructions for forking the template.
2. Ask for the git URL of the user's fork.
3. Ask where to clone it, defaulting to `~/repos/nix-flake`.
4. Clone the fork, then run `generate-hw`, `generate-user` and
   `create-new-system` with `--force` against the clone. `generate-hw` writes
   `modules/07-system/facter.json` when `nixos-facter` is available.
5. Ask whether to rebuild and reboot, rebuild only, or do neither. On rebuild,
   run `nixos-rebuild boot --flake <clone>#<host> --sudo` (D16).

## 4. Safety

- Never overwrite an existing `hardware.nix` or `user.nix` without an explicit
  confirmation flag.
- Refuse to embed a plaintext password; store only the hash.
- Keep every generated value out of the tracked defaults so a fresh fork
  contains no personal data.

## 5. Requirements

- `git` must be available on `PATH`; the script clones your fork with it.
- `nix-command` and `flakes` must be enabled before running the installer,
  for example `nix run github:ojuny-project/ojuny-template#setup`. On a fresh install
  they are off and every flake command fails with `experimental Nix feature
  'nix-command' is disabled`; enable them in `nix.conf`
  (`experimental-features = nix-command flakes`).
- The script calls `nix build` to pre-build the compiled targets one at a time
  before the rebuild it offers; that rebuild runs `nixos-rebuild`, which
  enables the flake features internally and does not accept
  `--extra-experimental-features`. The flag is needed for the `nix build`
  calls and the `nix run` that starts the installer.
- `nixos-generate-config` (from the NixOS install) is assumed present when the
  script runs on NixOS. When running on a non-NixOS Nix install, the script
  must fall back to reading an existing `hardware-configuration.nix` or ask the
  user to supply hardware data.
- `nixos-facter` must be on `PATH` for `generate-hw` and
  `regenerate-hardware` to write `facter.json`. The setup app provides it
  through its `generate-hw` wrapper. `nixos-facter` needs root; `generate-hw`
  runs it with `sudo` when it is not already root, and keeps the existing
  report if the probe cannot run.

## 6. Packaging

- Location: `scripts/setup.sh` (portable bash), exposed as `nix run .#setup` via
  a `perSystem` app that wraps the script with the needed tools (`git`,
  `nixos-generate-config`, `nixos-facter`, `nixos-rebuild`, `mkpasswd`, `nix`)
  (D14a). The clone target defaults to `~/repos/nix-flake` and can be changed
  with the prompt or the `OJUNY_CLONE_DIR` environment variable.

## 7. Interaction with the GUI

- The generated `01-users/01-user.nix` carries `@menu` / `@option` comments so
  the user can manage accounts and per-user home-manager settings in the GUI.
  The generated `07-system/00-hardware.nix` has no `@menu` header and never
  appears (D5, D6a).
- `07-system/09-facter.nix` is the Hardware profile page. It has the profile
  dropdown, read-only detected model, profile and state controls, and the
  effective GPU layout and source. The generated
  `07-system/00-hardware-quirks.nix` has no `@menu` header and never appears.
- The script never edits files that the GUI owns (the hand-written page files);
  it only creates the generated file and fills the templates.

## 8. Hardware profiles

`generate-hw` writes `modules/07-system/facter.json` with `nixos-facter`.
`regenerate-hardware` maps `smbios.system.manufacturer` and
`smbios.system.product` or `smbios.system.version` to one profile from
`modules/07-system/10-hardware-profile.nix` and writes
`modules/07-system/00-hardware-quirks.nix` with:

```nix
imports = [ inputs.nixos-hardware.nixosModules.<slug> ];
```

A profile that starts with `ojuny-` imports `self.modules.nixos.<slug>`
instead, for models with no nixos-hardware profile. When the facter report
lists a GPU variant that nixos-hardware splits out, the generator imports the
variant slug. `GPU_PROFILES` in `10-hardware-profile.nix` records the layouts
and variants; `hardware.graphics_card` is optional, so a missing key leaves the
layout `unknown` and the Graphics page falls back to its manual controls.

Both scripts also write one `boot.initrd.luks.devices."<mapper>".device` line
per open LUKS device, using the encrypted parent partition's UUID rather than
the filesystem UUID inside the mapper. This includes encrypted swap, so stage 1
can unlock it without the boot delay or missing-device failure. Lines that the
`nixos-generate-config` output already contains are not duplicated.

The Hardware report page (`09-facter.nix`) shows the detected model, profile
and state, the effective GPU layout and its source, and a profile dropdown.
`auto` uses the mapping. A non-`auto` value is honoured even when detection
fails. Apply a dropdown change without a root
`nixos-generate-config` run:

```sh
nix run .#regenerate-hardware -- --profile-only
```

The first run creates the file; stage it with
`git add modules/07-system/00-hardware-quirks.nix` before rebuilding.

`--profile <slug>` forces a profile for one run. An unmatched machine writes no
import and shows `unmatched`; an unsupported machine writes no import and shows
its slug with state `unsupported`. The checked-in table and states are in
`docs/hardware-coverage.md`.

## 9. Resolved decisions

- D6a generated/templated files under `modules/`.
- D13a single system, system-specific settings in the system directory; a
  second system replicates that directory.
- D14a bash script (`scripts/setup.sh`) exposed as `nix run .#setup`.
- D15a `system.stateVersion` written once, never prompted or exposed; default
  groups `networkmanager wheel`; default shell zsh.
- D16 the script offers to run `nixos-rebuild boot` (and optionally reboot) at
  the end; the user can decline.
- D18a `nix-command` and `flakes` must be enabled to run the installer;
  `nixos-rebuild` enables them internally for the rebuild.
