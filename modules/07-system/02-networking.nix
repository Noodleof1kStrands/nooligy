/*
  @menu
  displayname = "Networking";
  icon = "network-wireless-symbolic";
  order = 20;
  description = "NetworkManager and firewall";
  category = "07-System";
*/

{ self, inputs, ... }: {

  flake.modules.nixos.system-networking =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.ojuny.vpn.wireguard;
      primaryUser =
        if config.users.users ? user then
          config.users.users.user
        else
          lib.findFirst (user: user.isNormalUser or false) null (lib.attrValues config.users.users);
      primaryUserName = primaryUser.name or "user";
      primaryHome = primaryUser.home or "/home/${primaryUserName}";
      watchDir = if cfg.directory != "" then cfg.directory else "${primaryHome}/.config/ojuny/wireguard";
      importScript = pkgs.writeShellApplication {
        name = "ojuny-wireguard-import";
        runtimeInputs = with pkgs; [
          coreutils
          gnugrep
          gawk
          networkmanager
        ];
        text = builtins.readFile ./wireguard-import.sh;
      };
      importSettings = pkgs.writeText "ojuny-wireguard-settings" "${toString cfg.autoconnect}:${cfg.autoconnectProfile}";
    in
    {
      imports = [ self.modules.nixos.system-deploy-rs ];

      options.ojuny.network.deploy-rs.enable = lib.mkEnableOption "deploy-rs and remote deployment";

      options.ojuny.networking.hosts = lib.mkOption {
        type = lib.types.listOf (
          lib.types.submodule {
            options = {
              address = lib.mkOption {
                type = lib.types.str;
                default = "";
                description = "IP address the host names resolve to.";
              };
              hostNames = lib.mkOption {
                type = lib.types.str;
                default = "";
                description = "Space-separated host names for the address.";
              };
            };
          }
        );
        default = [ ];
        description = "Static host entries written to networking.hosts.";
      };

      options.ojuny.vpn.wireguard = {
        enable = lib.mkEnableOption "automatic WireGuard profile import";
        directory = lib.mkOption {
          type = lib.types.str;
          default = "";
          description = "Directory watched for WireGuard .conf files. Empty uses ~/.config/ojuny/wireguard for the primary user.";
        };
        autoconnect = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Connect one managed WireGuard profile at boot.";
        };
        autoconnectProfile = lib.mkOption {
          type = lib.types.str;
          default = "";
          description = "File basename of the profile to connect at boot. Empty uses the first profile.";
        };
      };

      config = {

        # @option widget = "switch"; label = "NetworkManager"; group = "Network";
        networking.networkmanager.enable = true;

        # @option widget = "switch"; label = "WireGuard profile folder"; group = "VPN"; groupOrder = 5; order = 10; description = "Watch a folder for WireGuard .conf files and import them into NetworkManager. Imported profiles appear in the DMS VPN panel.";
        ojuny.vpn.wireguard.enable = true;

        # @option widget = "text"; label = "Profile directory"; group = "VPN"; groupOrder = 5; order = 20; visibleWhen.path = "ojuny.vpn.wireguard.enable"; visibleWhen.equals = true; description = "Absolute path. Empty uses ~/.config/ojuny/wireguard for the primary user.";
        ojuny.vpn.wireguard.directory = "";

        # @option widget = "switch"; label = "Connect VPN at boot"; group = "VPN"; groupOrder = 5; order = 30; visibleWhen.path = "ojuny.vpn.wireguard.enable"; visibleWhen.equals = true; description = "Enable autoconnect for one managed WireGuard profile and disable it for the others.";
        ojuny.vpn.wireguard.autoconnect = false;

        # @option widget = "text"; label = "Profile at boot"; group = "VPN"; groupOrder = 5; order = 40; visibleWhen.path = "ojuny.vpn.wireguard.autoconnect"; visibleWhen.equals = true; description = "File basename of the profile to connect at boot. Empty uses the first profile in the folder.";
        ojuny.vpn.wireguard.autoconnectProfile = "";

        systemd.tmpfiles.rules = lib.mkIf cfg.enable [
          "d ${watchDir} 0700 ${primaryUserName} ${primaryUser.group or "users"} -"
        ];

        systemd.services.ojuny-wireguard-import = lib.mkIf cfg.enable {
          description = "Import WireGuard profiles from ${watchDir}";
          after = [ "NetworkManager.service" ];
          wants = [ "NetworkManager.service" ];
          wantedBy = [ "multi-user.target" ];
          restartTriggers = [
            importSettings
            importScript
          ];
          serviceConfig.Type = "oneshot";
          script = "${importScript}/bin/ojuny-wireguard-import ${lib.escapeShellArg watchDir} ${
            if cfg.autoconnect then "1" else "0"
          } ${lib.escapeShellArg cfg.autoconnectProfile}";
        };

        systemd.paths.ojuny-wireguard-import = lib.mkIf cfg.enable {
          wantedBy = [ "multi-user.target" ];
          pathConfig = {
            PathChanged = watchDir;
          };
        };

        # @option widget = "switch"; label = "Wi-Fi power saving"; group = "Wi-Fi"; visibleWhen.path = "networking.networkmanager.enable"; visibleWhen.equals = true; description = "Disable to fix stuttering on some Wi-Fi cards.";
        networking.networkmanager.wifi.powersave = true;

        # @option widget = "list"; label = "DNS servers"; group = "DNS"; description = "Static resolvers; leave empty to use DHCP.";
        networking.nameservers = [ ];

        # @option widget = "text"; label = "Domain"; group = "DNS"; description = "Local DNS search domain.";
        networking.domain = "";

        # @option widget = "text"; label = "Ethernet MAC address"; group = "Ethernet"; hidden = true; description = "Spoof the MAC of wired devices, e.g. 02:00:00:00:00:01.";
        networking.networkmanager.ethernet.macAddress = "stable";

        # @option widget = "switch"; label = "Predictable interface names"; group = "Ethernet"; hidden = true; description = "Use names like enp1s0 instead of eth0.";
        networking.usePredictableInterfaceNames = true;

        # @option widget = "switch"; label = "Firewall"; group = "Firewall";
        networking.firewall.enable = true;

        # @option widget = "switch"; label = "Log refused connections"; group = "Firewall"; visibleWhen.path = "networking.firewall.enable"; visibleWhen.equals = true; hidden = true;
        networking.firewall.logRefusedConnections = true;

        # @option widget = "list"; label = "Open TCP ports"; group = "Firewall"; visibleWhen.path = "networking.firewall.enable"; visibleWhen.equals = true;
        networking.firewall.allowedTCPPorts = [ ];

        # @option widget = "list"; label = "Open UDP ports"; group = "Firewall"; visibleWhen.path = "networking.firewall.enable"; visibleWhen.equals = true;
        networking.firewall.allowedUDPPorts = [ ];

        # @option widget = "list"; label = "Trusted interfaces"; group = "Firewall"; visibleWhen.path = "networking.firewall.enable"; visibleWhen.equals = true;
        networking.firewall.trustedInterfaces = [ "virbr0" ];

        # @option widget = "table-list"; label = "Static hosts"; group = "Hosts"; advanced = true; columns = [ "address" "hostNames" ]; columnTypes = [ "str" "str" ]; firstValueEditable = true; description = "Extra /etc/hosts entries. Host names are separated by spaces.";
        ojuny.networking.hosts = [ ];

        # Derived from the table above; no @option.
        networking.hosts = lib.listToAttrs (
          map (entry: {
            name = entry.address;
            value = lib.filter (name: name != "") (lib.splitString " " entry.hostNames);
          }) config.ojuny.networking.hosts
        );

      };

    };

}
