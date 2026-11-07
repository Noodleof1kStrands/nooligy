# Lifecycle operations

This covers machine handover, factory reset, full reset and generation
rollback.

Run the scripts from the Ojuny repository, or set `OJUNY_ROOT` to its path.
Both scripts accept `--dry-run` and `--help`.

## Machine handover

Machine handover transfers the machine to a new user. The system
configuration and hostname are kept. The old user data is removed.

```bash
nix run .#handover
```

The script:

1. Reads the host from `modules/07-system/00-host.nix`.
2. Backs up `modules/01-users/01-user.nix` under
   `/var/lib/ojuny/handover/<timestamp>/`.
3. Runs `generate-user --force` for the new account.
4. Runs `nixos-rebuild boot --flake <repo>#<host>`.
5. Shows the `/home` entries and requires `HANDOVER`.
6. Removes the home directories after the build succeeds.
7. Offers a reboot.

The new user is created on the next boot and their home is generated. If the
repository is inside `/home`, it is removed with the old user. Clone it again
after the handover.

Manual fallback:

```bash
generate-user --force
sudo nixos-rebuild boot --flake .#<host>
sudo find /home -mindepth 1 -maxdepth 1 ! -name lost+found -exec rm -rf -- {} +
sudo systemctl reboot
```

## Factory reset

Factory reset returns the template configuration to a fresh copy while keeping
the current user, their files, the hostname, the state versions and the
hardware configuration.

```bash
nix run .#factory-reset
```

The default template source is the repository's `origin` remote. Use
`--template` to reset from another fork or URL. Commit and push the template
changes you want to keep before running the reset; the fresh copy replaces the
repository contents.

```bash
nix run .#factory-reset -- --template https://github.com/you/ojuny-template
```

The script keeps:

- `modules/01-users/01-user.nix`
- `modules/07-system/00-host.nix`
- `modules/07-system/00-hardware.nix`
- `modules/07-system/facter.json`, when present
- `modules/07-system/00-hardware-quirks.nix`, when present
- the hostname and `system.stateVersion`
- `/home` and all user files

Everything else in the repository is replaced with the fresh template.

The script backs up the kept files under
`/var/lib/ojuny/factory-reset/<timestamp>/`, requires `RESET`, rebuilds with
`nixos-rebuild boot`, and offers a reboot.

## Full reset

A full reset is a reinstall through the template setup path. It does not keep
the user or their files. Back up anything that must survive first.

Boot the Ojuny ISO and run the template setup script, or use the setup path
documented in `docs/03-host-setup.md`.

## NixOS generations

NixOS generations are complete bootable systems. They are not incremental
snapshots and do not need a snapshot daemon, a recovery flow or a restore step.

- Every retained generation boots at normal speed.
- Any generation can be selected from the bootloader at any time.
- Switching back and forth is supported.
- A failed update or rebuild is recovered by rebooting into the previous
  generation.
- The previous generation is a normal, usable system with its own users,
  services and configuration.
