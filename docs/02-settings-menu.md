# 02 - Settings menu

The master page taxonomy. Every page is one file. A file with an `@menu`
header becomes a menu in nix-settings-gui; a file without one is skipped by
the scanner and is used for under-the-hood settings. This document defines what
each page contains and is the spec the repo is built from.

## 1. Menu model recap (from nix-settings-gui)

- One `.nix` file equals one menu, and only if it has an `@menu` header.
- `/* @menu ... */` sets `displayname`, `icon`, `order`, `description`,
  `category`, `systems`, `hidden`.
- `/* @option ... */` above an assignment sets `widget`, `label`,
  `description`, `group`, `order`, `choices`, `min`, `max`, `step`, `unit`,
  `advanced`, `hidden`, `readonly`, `nullable`, and list helpers.
- Assignments without an `@option` comment are not exposed as controls at the
  top level. Inside an annotated `submodule` block unannotated children are
  still scanned and rendered, so such a child must carry `hidden = true` (with
  Advanced off) to stay out of the GUI.
- Widgets: `switch`, `dropdown`, `radio`, `spin`, `slider`, `text`,
  `multiline`, `path`, `package`, `packages`, `list`, `color`, `submodule`,
  `raw`.
- Custom widgets: `bar`, `dock`, `menu`, `monitors`, `plugins`, `keybinds`,
  `theme`, `horizontal-submodule`, `table-attrset`, `table-list`.
- Type, description, default, and choices come from nixd (fallback `nix eval`),
  so a page only needs the assignment plus the `@option` comment.

## 2. Non-menu files (D5)

- A file with no `@menu` header is ignored by the scanner. Use this for
  under-the-hood settings that should not be user-edited.
- `03-desktop/00-mango.nix` is the under-the-hood mango file.
- `07-system/00-hardware.nix` is generated and has no menu.
- Values that must never be changed (for example `system.stateVersion`) live
  in a menu file but carry no `@option` comment, so they are never shown.

## 3. Category map (final)

Categories are explicit strings in each page's `@menu` header. The GUI prints
the `category` string verbatim as the section heading and sorts categories by
that string, so the numeric prefix both orders the headings and is shown.
Sorting is ASCII, so `01-` ... `07-` precede unprefixed names such as
`Patches`. Physical folders keep their original grouping and do not set the
category; the `@menu` `category` string is authoritative.

| Category | Pages |
|----------|-------|
| `01-Users` | user, commonsettings |
| `02-Core` | display, input, binds, gestures, theme, typography, compositor, shell, browser, git, terminal, autostart, updates, nixsettings, audio |
| `03-Desktop` | login, mangosettings, mangomaster, mangodwindle, scroller, mangoworkspaces, notifications, screensaver, clipboard, monocle-deck |
| `04-GUI` | bar, dock, launcher, dashboard, controlcenter, menu |
| `05-Applications` | applist, screenshot, multimedia, office, vesktop, steam, kdeconnect, app format compatibility |
| `06-Utility` | dux-tools, webapps, plugins |
| `07-System` | configuration, networking, bluetooth, graphics, plymouth |
| `Patches` | pre-included: patch-development, patch-docker, patch-flatpak, patch-impermanence, patch-nixshell, patch-remote-desktop, patch-virtualization; installed patches add more |

Pages marked "(proposed)" below are additions to the scaffold and are the
current working set for review.

## 4. Pages

### 01-users

- `01-user.nix` `[menu]`. The user accounts and their home-manager settings.
  The `users` widget manages `users.users`; with `homeManager = true` it also
  manages the sibling `home-manager.users` block. The setup script seeds a
  neutral `user` account, and additional accounts are added in the GUI. The
  editor default is global, not per-user.
- `02-commonsettings.nix` `[menu]`. User settings that apply to all users:
  shared home-manager modules and shared user preferences (D8).

### 02-core

- `00-colors.nix` `[no menu]`. Named color helpers derived from the stylix
  palette.
- `01-display.nix` `[menu]`. Monitors, tearing and HDR.
- `02-input.nix` `[menu]`. Keyboard, mouse, trackpad, touch and Fcitx5 input
  methods.
- `03-binds.nix` `[menu]`. Key, mouse, axis and gesture bindings, plus the
  Window snap group that tunes the Super+H `ojuny-snap` bind. The snap
  behavior itself is documented in ojuny-desktop.
- `04-gestures.nix` `[menu]`. Touchpad swipe gestures and swipe tuning.
- `05-theme.nix` `[menu]`. Palette, polarity, popup opacity and wallpaper.
- `05-typography.nix` `[menu]`. Fonts, shell text rendering, icon themes and
  cursors.
- `05-compositor.nix` `[menu]` "Compositor looks". Gaps, borders, corner
  radius, mango blur, shadows, decoration, animations and app theming.
- `05-shell.nix` `[menu]` "Shell looks". Interface shape and density, surface
  blur, floating windows, motion, surfaces and color modes for Dux Modular Shell.
- `06-browser.nix` `[menu]`. Web browser, default browser and MIME
  associations; file manager and remote scheme defaults live on the
  Applications page and point at dux-files.
- `07-git.nix` `[menu]`. Git and version control defaults.
- `08-terminal.nix` `[menu]`. Terminal emulator, zsh, aliases, command line
  tools and the btop, lazygit and yazi TUIs.
- `09-autostart.nix` `[menu]`. Commands run at login and on reload.
- `10-updates.nix` `[menu]`. Update tooling, the repo-sync checker and a disabled updater.
- `11-nixsettings.nix` `[menu]`. Nix tooling, `nix-shell-gui`, `nix-regedit`
  and the LAN cache. The LAN cache is disabled by default and detects the
  connected subnet (auto) when enabled; the fixed ranges field is hidden while
  auto is on and the scan interval defaults to 10 minutes. Enabling "Use only
  the LAN cache" hides the substituter list because the local daemon replaces
  it and fetches upstream paths itself.

### 03-desktop

- `00-mango.nix` `[no menu]`. Under-the-hood mangoWM + Dux Modular Shell session
  switch (D5).
- `01-login.nix` `[menu]`. Greeter and display manager (D9).
- `02-mangosettings.nix` `[menu]`. Layouts, focus, tiling and workspaces.
- `03-mangomaster.nix` `[menu]`. Master and stack layout.
- `04-mangodwindle.nix` `[menu]`. Dwindle tiling layout.
- `05-scroller.nix` `[menu]`. Horizontal scrolling window layout.
- `06-mangoworkspaces.nix` `[menu]`. Workspace and tag settings.
- `07-notifications.nix` `[menu]`. Notification popups. Date, time and recurring
  notices are created in KAlarm and Nix seeds no alarms; battery alerts remain
  on the Power page, and weather is a KAlarm command alarm that displays a
  weather command's output.
- `08-clipboard.nix` `[menu]`. Clipboard history settings.
- `11-screensaver.nix` `[menu]`. Configurable ASCII screensaver command and idle timeout.

### 04-gui

- `01-bar.nix` `[menu]`. Bar layout, widgets and island style. Preset
  definitions move out of this template into ojuny-desktop; what stays here is
  the preset dropdown (`ojuny.dux.barPreset`), the custom bar editor
  (`ojuny.dux.customBar`) and the `@widget-preset` catalog.
- `02-dock.nix` `[menu]`. Dock appearance and behaviour.
- `03-launcher.nix` `[menu]`. App launcher style, behaviour and plugin
  triggers.
- `04-dashboard.nix` `[menu]`. Dashboard cards, tabs and their placement.
- `05-controlcenter.nix` `[menu]`. Control center widgets and layout.
- `06-menu.nix` `[menu]`. Nix managed application menu. The menu tree is a
  literal attribute set that the `menu` widget reads and writes as a whole.
- Menu conventions and the patch extension point:
  - A toggle is a Run Command row with `checked` set, as Stay Awake and Night
    Mode already do. There is no toggle action type.
  - A patch action is a Run Command row that calls a command the installed
    patch provides. There is no patch provider or action type.
  - Patches and non-GUI modules assign rows to
    `desktop.ojuny.dankMenu.extraEntries.<id>`, using the same row shape as
    `desktop.ojuny.dankMenu.menu`. The generator merges the two with
    `lib.recursiveUpdate` before writing the menu JSON, so an extra can add a
    new section or a child of an existing section without editing `menu`.
  - The editor only reads and writes `desktop.ojuny.dankMenu.menu`. Extra
    entries do not appear in the editor, and a GUI save never removes one.
  - A top-level row with `provider = "apps"` keeps no children, because the
    apps provider generates its own submenu.

### 05-applications

- `01-applist.nix` `[menu]`. Applications installed system-wide (D8),
  including dux-files (`dfiles`) as the default file browser, which replaces
  Nautilus.
- `07-screenshot.nix` `[menu]`. satty, OCR, the capture wrappers and the
  screenshot keybinds. The binds live in the always-active common mode.
- `02-multimedia.nix` `[menu]`. Viewers (media player, image viewer) and tools
  (OBS, Audacity, GIMP, satty).
- `03-office.nix` `[menu]`. Office suite, document tools, ArtCraft apps and
  Obsidian notes.
- `04-vesktop.nix` `[menu]`. Discord client.
- `05-steam.nix` `[menu]`. Steam, Proton GE, DW-Proton with DXVK-Sarek,
  Xbox controller support and gaming (D12).
- `06-kdeconnect.nix` `[menu]`. Phone notifications, file transfer and
  remote input.
- `08-appimage.nix` `[menu]`. App format compatibility. The AppImage half is
  the AppImage runtime and double-click handler: it enables `programs.appimage`,
  registers the binfmt handlers, installs a hidden `ojuny-appimage.desktop`
  handler, and sets it as the default for `application/vnd.appimage` and
  `application/x-iso9660-appimage`. The "AppImage environment includes" list
  adds packages only to the AppImage runtime, not to the system environment.
  The runtime also carries the system and Stylix fonts, icons, cursor and GTK
  theme. The same page has an optional Raven switch, off by default. It installs
  the experimental Raven runtime and associates `.exe`, `.msi` and `.bat` files
  with it. Raven is not guaranteed to run a given program; `.bat` support is
  best-effort and interactive scripts need a terminal. It does not affect Steam
  or Proton, and it uses Raven's default prefix unless `RAVEN_PREFIX` is set.
  A failed launch writes a report under `${XDG_STATE_HOME:-$HOME/.local/state}/ojuny/raven`
  and opens a floating dialog with the log, the Raven revision, hardware, OS
  including `ID_LIKE`, kernel, compositor, selected session environment, the Raven issue tracker
  link, and a survey-mode relaunch button. Survey mode warns that it may break
  the Raven configuration and is gated by a confirmation.

### 06-utility

- `00-dux-tools.nix` `[menu]`. dsearch, Dux Files, Dux Calendar and dgop.
  Nix owns only policy keys for Dux Files and Dux Calendar. At activation it
  merges those keys into each app's existing `ui-settings.json` and leaves every
  other key, and every account outside the file, untouched. Dux Calendar owns
  its initial view, so the page has no view control. Dux Calendar has no
  dashboard view yet, so a dashboard tab remains open work.
- `01-webapps.nix` `[menu]`. Chromium based web applications.
- `02-plugins.nix` `[menu]`. Dux Modular Shell plugins that ship with this desktop.

### 07-system

- `00-hardware.nix` `[no menu]` (generated). Filesystems, swap, kernel
  modules, microcode, hostPlatform (D5, D6).
- `00-host.nix` `[no menu]`. The host configuration: system and module list.
- `00-imports.nix` `[no menu]`. The import list that decides which pages a
  host loads.
- `_00-ssh-test.nix` `[no menu]`. Temporary SSH test module.
- `01-configuration.nix` `[menu]`. Hostname, time zone, locale, console
  keymap, the patches switch, and the package source controls. The package
  source group selects source, the newest release, or a named release from each
  repository's `binary-url.json`; the manual has its own selector and defaults
  to source. Options marked advanced are per-tool overrides and release tags.
  `system.stateVersion` present but never
  exposed (D15).
- `02-networking.nix` `[menu]`. NetworkManager, firewall, hosts, DNS and the
  WireGuard profile drop folder. Drop a `.conf` file into
  `~/.config/ojuny/wireguard` and it is imported into NetworkManager, where it
  appears in the DMS VPN panel. Removing the file removes the imported profile.
  "Connect VPN at boot" enables autoconnect for one named profile and disables
  it for every other VPN connection, so only one tunnel starts at boot.
- `03-bluetooth.nix` `[menu]`. Bluetooth pairing and services.
- `04-graphics.nix` `[menu]`. Graphics drivers, NVIDIA branches, hybrid
  PRIME and Mesa offload, compute accelerators and hardware acceleration.
  The GPU vendor target `auto` reads the facter report; the other targets are
  manual overrides. When a nixos-hardware profile owns the GPU settings, the
  profile page marks them managed and the manual driver, PRIME and bus ID
  controls do not take effect. The supported combinations are listed in
  `hardware-matrix.md`.
- `09-facter.nix` `[menu]`. Hardware profile selection, the detected model,
  profile and coverage state, and the effective GPU layout and its source.
  `auto` uses `regenerate-hardware`; a concrete profile is a manual override.
  Applying a change rewrites `00-hardware-quirks.nix` with
  `nix run .#regenerate-hardware -- --profile-only`.
- `07-plymouth.nix` `[menu]`. Stylix-coloured Plymouth boot splash with the Ojuny logo.
- `12-multiboot.nix` `[menu]`. Optional rEFInd helper on UEFI. Off by default.
  It adds an "Other systems" systemd-boot entry and scans internal drives at
  boot. The installer enables it when another internal system is found. It is
  documented in `09-multiboot.md`.

### patches

- `00-patches.nix` `[no menu]`. Imports every `patch-*` module under
  `modules/patches/` while `ojuny.patches` is enabled.
- The template pre-includes seven patches: `patch-development`, `patch-docker`,
  `patch-flatpak`, `patch-impermanence`, `patch-nixshell`,
  `patch-remote-desktop` and `patch-virtualization`. Six have counterparts in
  the `ojuny-patches` registry and must be kept in sync with it;
  `patch-impermanence.nix` has no registry counterpart, so the pre-included
  set does not mirror the registry. Do not edit a pre-included copy only in the
  template.
- Additional patches are installed with `ojuny-patches install <id>`, which
  places `<id>.nix` in `modules/patches/`; `00-patches.nix` imports it as a
  local module. The settings menu then shows one page per installed patch.
  `ojuny-patches list available` lists what the registry offers, and the
  registry is the source of truth for patch names, metadata and content.
- Editor patches: `patch-development` (VSCodium, language servers and
  formatters), plus `patch-nixvim`, `patch-emacs`, `patch-helix` and
  `patch-zed`. Helix and Zed theme through Stylix and each own a
  `defaultEditor` switch that is off by default.

## Coverage ledger

[Dux Modular Shell settings coverage](dux-settings-coverage.md) is the row ledger for the migration. The machine-readable copy is [dux-settings-coverage.csv](dux-settings-coverage.csv).

At migration time 1099 of 1418 rows are covered under `desktop.ojuny.dux` (counted from the `status` column of `dux-settings-coverage.csv` on 2026-11-03). Each row is in one of four states: covered, stylix-owned through an exposed stylix option, deferred with a phase in the coverage document, or unexposed with a stated reason. A row marked uncovered in the ledger is not claimed as covered here.

## 5. Resolved decisions

- D1a mangoWM + Dux Modular Shell only.
- D2a manual install, generated `hardware.nix` only.
- D3a template options under top-level `ojuny.*`.
- D4 page set as listed above (proposed pages under review).
- D5 no `@menu` means not a menu; unannotated values never shown at the top
  level (inside an annotated `submodule` block they still render unless
  `hidden = true`).
- D6a generated files kept in `modules/`, `hardware.nix` is not a menu.
- D7a one file declares the nixos and/or home-manager module it needs.
- D8 commonsettings and applist as defined.
- D9a dedicated login page.
- D10 all update tooling in `02-core/10-updates.nix`.
- D11a shell and ghostty in `02-core/08-terminal.nix`, fonts in
  `02-core/05-typography.nix`.
- D12 Steam built in; Prism Launcher through `patch-prismlauncher`.
- D13 system-specific settings in the system directory; per-user settings in
  that user's `user.nix`; all system files templated except generated
  `hardware.nix`.
- D14a bash setup script.
- D15a stateVersion never exposed.
- D16 no rebuild from the script.
- D17 fastfetch included, default `fastfetch-den`, `user` as default user.
- D18a experimental-features flag on every nix call until the applied config
  enables the features permanently.
- T1 the template includes nix-settings-gui, nix-regedit, nix-shell-gui, and
  simple-nix-update-gui; dendrite-menu is dropped.
- T2 nix-shell-gui and nix-regedit in `02-core/11-nixsettings.nix`;
  nix-settings-gui and simple-nix-update-gui in `02-core/10-updates.nix`.
- Lockscreen and power in `07-system/06-lock.nix` and `07-system/05-power.nix`.
- Fold confirmations: wallpaper into `02-core/05-theme.nix`, workspaces into
  `03-desktop/06-mangoworkspaces.nix`, OSD into `03-desktop/09-osd.nix`.

## 6. Remaining open

- Confirm the proposed pages to include.
