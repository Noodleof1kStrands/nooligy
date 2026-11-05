/*
  @menu
  displayname = "Gaming";
  icon = "applications-games-symbolic";
  order = 50;
  description = "Steam and gaming";
  category = "05-Applications";
*/

{ self, inputs, ... }: {

  flake.modules.nixos.applications-steam =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      steam-gamescope = pkgs.writeShellScriptBin "steam-gamescope" ''
        if [ -z "''${XDG_SESSION_ID:-}" ]; then
          echo "steam-gamescope: XDG_SESSION_ID is not set" >&2
          exit 1
        fi
        deadline=$((SECONDS + 15))
        while [ "$(${config.systemd.package}/bin/loginctl show-session "$XDG_SESSION_ID" -p Active --value 2>/dev/null)" != "yes" ]; do
          if [ "$SECONDS" -ge "$deadline" ]; then
            echo "steam-gamescope: session $XDG_SESSION_ID did not become active" >&2
            exit 1
          fi
          sleep 0.2
        done
        exec gamescope --steam -- ${config.programs.steam.package}/bin/steam -tenfoot -pipewire-dmabuf
      '';

      gamescopeSessionFile =
        (pkgs.writeTextDir "share/wayland-sessions/steam.desktop" ''
          [Desktop Entry]
          Name=Steam
          Comment=A digital distribution platform
          DesktopNames=gamescope;Steam;
          Exec=${steam-gamescope}/bin/steam-gamescope
          Type=Application
        '').overrideAttrs
          (_: {
            passthru.providedSessions = [ "steam" ];
          });
    in
    {

      options.ojuny.steam = {
        compat = lib.mkEnableOption "Wine, winetricks, protontricks and gamescope";

        gamescopeSession = lib.mkEnableOption "the gamescope Steam session";

        protonGE = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Add Proton GE to Steam's compatibility tools.";
        };

        extest = lib.mkEnableOption "the extest library for Steam Input on Wayland";
      };

      options.ojuny.hardware.xpadneo = lib.mkEnableOption "the xpadneo driver for Xbox One and Series wireless controllers";

      config = {
        # @option widget = "switch"; label = "Steam"; group = "Steam"; groupOrder = 10; order = 1;
        programs.steam.enable = true;

        # @option widget = "switch"; label = "Windows compatibility tools"; group = "Steam"; description = "Install Wine, winetricks, protontricks and gamescope so non-Steam Windows games and launchers can run."; visibleWhen.path = "programs.steam.enable"; visibleWhen.equals = true;
        ojuny.steam.compat = true;

        # @option widget = "switch"; label = "Proton GE"; group = "Steam"; description = "Community Proton build with extra codec and performance patches, offered alongside the official Proton versions in Steam Play."; visibleWhen.path = "programs.steam.enable"; visibleWhen.equals = true;
        ojuny.steam.protonGE = true;

        # @option widget = "switch"; label = "Steam Input on Wayland"; group = "Steam"; description = "Load the extest library into Steam so Steam Input works on Wayland by translating X11 input events to uinput events. Leave off unless Steam Input misbehaves on Wayland; it is unnecessary on X11."; visibleWhen.path = "programs.steam.enable"; visibleWhen.equals = true;
        ojuny.steam.extest = true;

        programs.steam.extest.enable = config.ojuny.steam.extest;

        # Derived, no @option: feeds Steam's compatibility tool list.
        programs.steam.extraCompatPackages = lib.optionals config.ojuny.steam.protonGE [
          pkgs.proton-ge-bin
        ];

        # @option widget = "switch"; label = "Gamescope session"; group = "Steam"; description = "Add a sessions entry that boots straight into Steam Big Picture through gamescope."; visibleWhen.path = "programs.steam.enable"; visibleWhen.equals = true;
        ojuny.steam.gamescopeSession = true;

        programs.gamescope.enable = lib.mkIf (
          config.ojuny.steam.compat || config.ojuny.steam.gamescopeSession
        ) true;

        services.displayManager.sessionPackages = lib.optionals config.ojuny.steam.gamescopeSession [
          gamescopeSessionFile
        ];

        # @option widget = "switch"; label = "Xbox wireless controller driver"; group = "Controllers"; groupOrder = 20; description = "Install the xpadneo kernel driver for Xbox One and Xbox Series controllers over Bluetooth. It only adds quirks for those controllers; wired USB and most other Bluetooth controllers work without it.";
        ojuny.hardware.xpadneo = false;

        hardware.xpadneo.enable = config.ojuny.hardware.xpadneo;

        # @option widget = "switch"; label = "GameMode"; group = "Steam"; description = "Lets games request a temporary performance profile (governor, niceness, IO priority). Works independently of Steam and other launchers.";
        programs.gamemode.enable = true;

        # @option widget = "switch"; label = "Remote Play firewall"; group = "Steam"; description = "Open the ports Steam Remote Play uses on the local network."; visibleWhen.path = "programs.steam.enable"; visibleWhen.equals = true;
        programs.steam.remotePlay.openFirewall = true;

        # @option widget = "switch"; label = "LAN game transfers"; group = "Steam"; description = "Allow Steam to copy game downloads between PCs on the local network."; visibleWhen.path = "programs.steam.enable"; visibleWhen.equals = true;
        programs.steam.localNetworkGameTransfers.openFirewall = true;

        # @option widget = "switch"; label = "Dedicated server firewall"; group = "Steam"; advanced = true; description = "Open ports for hosted game servers."; visibleWhen.path = "programs.steam.enable"; visibleWhen.equals = true;
        programs.steam.dedicatedServer.openFirewall = false;

        environment.systemPackages = lib.mkIf config.ojuny.steam.compat [
          pkgs.wineWow64Packages.stable
          pkgs.winetricks
          pkgs.protontricks
        ];
      };

    };

}
