# Install time benchmark

This is the measurement protocol for comparing Ojuny install time with
Omarchy and with earlier Ojuny ISOs.

## Controlled setup

Keep every run identical:

- same test device and firmware settings
- same USB drive, Ventoy version and USB port
- same cable
- same target disk and partition layout
- same network connection, or no network for every run
- same installer choices
- same start and stop points

Only the ISO should differ between Ojuny runs.

## Timing points

Record these four points:

1. Installer start
2. Disk write complete
3. First boot
4. Login ready

Use the same definition for each point on every installer.

## Run count

Run each ISO at least three times. Report the median and the individual runs.
Record the ISO version, SHA-256 hash and test date.

Both installers write a timestamped install log to `~/ojuny-install.log` on the
installed system. It includes the installer phases and the `nixos-install`
output, so copy it off the machine after each run.

## Test device

- HP laptop, AMD Ryzen 3 3200U, 24 GB DDR4
- 256 GB NVMe target
- External JMicron USB NVMe enclosure, 512 GB with DRAM cache
- Ventoy USB, same cable and USB port for every run
- Timing excludes pre-install configuration and the post-install reboot

## Results

| Installer | ISO version | ISO SHA-256 | Date | Run 1 | Run 2 | Run 3 | Median |
|---|---|---|---|---|---|---|---|
| Omarchy | pending | pending | 2026-11-06 | 2:00 | | | 2:00 |
| Ojuny online | current | pending | 2026-11-06 | 25:00 | | | 25:00 |
| Ojuny discovery | current | pending | 2026-11-06 | 18:00 | | | 18:00 |
| Ojuny offline | current | pending | 2026-11-06 | 60:00 | | | 60:00 |

These Ojuny runs used a 50 Mb/s download link over Wi-Fi 5 with one LAN
cache peer. Ojuny-specific packages are prebuilt on every ISO, so the install
is a store copy, not a source build.

The discovery run had the full closure on the current device and network
traffic was primarily local. Its 18-minute time is therefore copy and install
overhead, not a missing cache.

The offline ISO carries a larger closure and uses a higher compression level.
It also rebuilds every derivation that changes with the installer result:
filesystem layout, hardware, username, password and anything those affect.
Those are often file-generation and symlink derivations rather than compiled
packages, but they are still Nix builds. The build frontier exists for exactly
that reason. The one-hour offline time therefore needs a phase breakdown before
it is treated as a regression.

Before the prebuilt packages landed, the online-only ISO took 90 minutes
because the Ryzen 3 built the five Rust programs. Rebuilding every Ojuny target
on the i7-8565U test machine takes three to four hours, mostly ISO assembly.
The build-all path builds the Rust packages once and reuses them for the ISOs,
so that cost is carried by the ISO build, not by the user install.

The Omarchy baseline is the actual install only: it starts after the
configurator and ends when the installer reports completion. It excludes the
post-install reboot and any pre-install configuration.

Omarchy is fast because the current ISO writes a pre-built Arch Linux and
Omarchy root filesystem image to the target with `zstdcat | dd`, grows it to
the partition, then installs only the per-machine packages and runs the chroot
setup. The multi-gigabyte ISO carries that image and the offline package
mirror. It does not download or pacstrap the whole system during the install.

## Notes

- Omarchy is the baseline for the same hardware.
- Ojuny runs compare ISO versions on the same device.
- Do not compare runs made on different USB drives, ports or target disks.
- Record any installer prompt that waits for input and exclude idle time only
  if every run excludes it identically.
