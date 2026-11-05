/* @menu
   displayname = "Updates";
   icon = "software-update-available-symbolic";
   order = 100;
   description = "Update tooling, the repo-sync checker and a disabled updater. Ojuny never updates on its own: update the flake repository, then rebuild. Roll back from the systemd-boot generation menu or with sudo nixos-rebuild switch --rollback --flake <repo>#<host>. The nix-monitor GC button opens nix-cleaner and its Rebuild button opens nix-settings-gui; nix-monitor reports completed when that launcher exits, not when the work finishes, and Cancel closes the launcher. Cleaning runs through the dev.den.nix-cleaner.clean polkit action and pkexec, never sudo. nix-settings-gui rebuilds only when ~/.config/nix-settings-gui/config.json contains rebuild_command, which setup.sh and the installer write; without that file the rebuild stays unavailable until Configure writes one.";
   category = "02-Core";
   hidden = true;
*/

{ self, inputs, ... }: {

  flake.modules.nixos.system-updates =
    { config, lib, pkgs, ... }:
    let
      /* @option widget = "text"; label = "Flake URI override"; group = "Update daemon"; groupOrder = 20; order = 10; visibleWhen.path = "services.simple-nix-update-gui.enable"; visibleWhen.equals = true; description = "Leave empty to use the flake URI set during setup. Use git+https for private repositories so the logged-in user's credential helper is used."; */
      flakeUriOverride = "";

      /* @option widget = "text"; label = "Clone path override"; group = "Update daemon"; groupOrder = 20; order = 60; visibleWhen.path = "services.simple-nix-update-gui.enable"; visibleWhen.equals = true; description = "Leave empty to use the clone path set during setup. Where the daemon clones the flake, relative to the user's home."; */
      clonePathOverride = "";
    in
    {

      imports = [
        inputs.nix-settings-gui.nixosModules.default
        inputs.simple-nix-update-gui.nixosModules.default
      ];

      services.nix-settings-gui.enable = true;

      /* @option widget = "switch"; label = "Simple Nix Update GUI"; group = "Tools"; groupOrder = 10; order = 10; description = "Repo-sync checker for a flake repository, not a package updater. It keeps an installed system in step with its remote flake. Kept off, so its daemon and tray do not run."; */
      services.simple-nix-update-gui.enable = false;

      services.simple-nix-update-gui.flakeUri =
        lib.mkIf (flakeUriOverride != "") flakeUriOverride;

      /* @option widget = "dropdown"; label = "Check interval"; group = "Update daemon"; groupOrder = 20; order = 20; choices = [ "30m" "1h" "6h" "12h" "1d" ]; visibleWhen.path = "services.simple-nix-update-gui.enable"; visibleWhen.equals = true; */
      services.simple-nix-update-gui.checkInterval = "1h";

      /* @option widget = "switch"; label = "Notify when updates are available"; group = "Update daemon"; groupOrder = 20; order = 30; visibleWhen.path = "services.simple-nix-update-gui.enable"; visibleWhen.equals = true; */
      services.simple-nix-update-gui.autoNotify = true;

      /* @option widget = "switch"; label = "Use nix-output-monitor for build graphing"; group = "Update daemon"; groupOrder = 20; order = 40; visibleWhen.path = "services.simple-nix-update-gui.enable"; visibleWhen.equals = true; */
      services.simple-nix-update-gui.useNom = true;

      /* @option widget = "switch"; label = "Start tray icon on login"; group = "Update daemon"; groupOrder = 20; order = 50; visibleWhen.path = "services.simple-nix-update-gui.enable"; visibleWhen.equals = true; */
      services.simple-nix-update-gui.trayAutostart = true;

      services.simple-nix-update-gui.clonePath = lib.mkMerge [
        (lib.mkIf (clonePathOverride != "") clonePathOverride)
        (lib.mkDefault config.ojuny.repoPath)
      ];

      /* DMS updater policy. updaterAllowAUR is deliberately unexposed: DMS marks it hidden and this system is NixOS, which has no AUR backend. */

      /* @option widget = "switch"; label = "Check on start"; group = "Updater"; groupOrder = 30; order = 10; advanced = true; description = "Run an update check when the shell starts. The DMS updater is off in the shipped configuration; enabling this or any other key here is your own choice. Ojuny never updates automatically."; applyCommand = "dms ipc call settings set updaterCheckOnStart %%val%%"; */
      desktop.ojuny.dux.settings.updaterCheckOnStart = false;

      /* @option widget = "dropdown"; label = "Check interval"; group = "Updater"; groupOrder = 30; order = 20; advanced = true; choices = [ "900" "1800" "3600" "14400" "86400" "0" ]; description = "Seconds between checks. 900 = 15 min, 1800 = 30 min, 3600 = 1 h, 14400 = 4 h, 86400 = 1 day, 0 = never."; applyCommand = "dms ipc call settings set updaterIntervalSeconds %%val%%"; */
      desktop.ojuny.dux.settings.updaterIntervalSeconds = 0;

      /* @option widget = "switch"; label = "Notify when updates are available"; group = "Updater"; groupOrder = 30; order = 30; advanced = true; applyCommand = "dms ipc call settings set updaterNotify %%val%%"; */
      desktop.ojuny.dux.settings.updaterNotify = false;

      /* @option widget = "switch"; label = "Pause checks on battery"; group = "Updater"; groupOrder = 30; order = 40; advanced = true; applyCommand = "dms ipc call settings set updaterPauseOnBattery %%val%%"; */
      desktop.ojuny.dux.settings.updaterPauseOnBattery = false;

      /* @option widget = "switch"; label = "Include Flatpak"; group = "Updater"; groupOrder = 30; order = 50; advanced = true; applyCommand = "dms ipc call settings set updaterIncludeFlatpak %%val%%"; */
      desktop.ojuny.dux.settings.updaterIncludeFlatpak = false;

      /* @option widget = "switch"; label = "Reopen after upgrade"; group = "Updater"; groupOrder = 30; order = 60; advanced = true; description = "Restart the shell after an upgrade."; applyCommand = "dms ipc call settings set updaterReopenAfterUpgrade %%val%%"; */
      desktop.ojuny.dux.settings.updaterReopenAfterUpgrade = false;

      /* @option widget = "switch"; label = "Upgrade in window"; group = "Updater"; groupOrder = 30; order = 70; advanced = true; description = "Run the upgrade without a terminal window. Ignored when the backend needs a terminal."; applyCommand = "dms ipc call settings set updaterUpgradeInWindow %%val%%"; */
      desktop.ojuny.dux.settings.updaterUpgradeInWindow = false;

      /* @option widget = "spin"; label = "Minimum notify interval"; group = "Updater"; groupOrder = 30; order = 90; advanced = true; min = 0; max = 604800; step = 60; unit = "s"; description = "Seconds before the updater may repeat an update notification. 86400 = 1 day."; applyCommand = "dms ipc call settings set updaterNotifyMinSeconds %%val%%"; */
      desktop.ojuny.dux.settings.updaterNotifyMinSeconds = 86400;

      /* @option widget = "list"; label = "Ignored packages"; group = "Updater"; groupOrder = 30; order = 80; advanced = true; description = "Package names the updater leaves out of the available update list."; */
      desktop.ojuny.dux.settings.updaterIgnoredPackages = [ ];

    };

}
