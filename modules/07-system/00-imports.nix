{ self, ... }: {

  flake.modules.nixos.host-imports = {

    imports = [
      self.modules.nixos.system-configuration
      self.modules.nixos.system-hardware
      self.modules.nixos.system-facter
      self.modules.nixos.system-hardware-profile
      self.modules.nixos.system-bootloader
      self.modules.nixos.system-secureboot
      self.modules.nixos.system-networking
      self.modules.nixos.system-bluetooth
      self.modules.nixos.system-graphics
      self.modules.nixos.system-plymouth
      self.modules.nixos.system-power
      self.modules.nixos.system-lock
      self.modules.nixos.system-accessibility
      self.modules.nixos.system-nixsettings
      self.modules.nixos.system-updates
      self.modules.nixos.system-first-boot

      self.modules.nixos.users-commonsettings
      self.modules.nixos.users
      self.modules.nixos.users-user-editor

      self.modules.nixos.desktop-mango
      self.modules.nixos.desktop-mangosettings
      self.modules.nixos.desktop-mangomaster
      self.modules.nixos.desktop-mangodwindle
      self.modules.nixos.desktop-mangoworkspaces
      self.modules.nixos.desktop-monocledeck
      self.modules.nixos.desktop-scroller
      self.modules.nixos.desktop-display
      self.modules.nixos.desktop-style-theme
      self.modules.nixos.desktop-style-typography
      self.modules.nixos.desktop-style-compositor
      self.modules.nixos.desktop-style-shell
      self.modules.nixos.desktop-bar
      self.modules.nixos.desktop-dock
      self.modules.nixos.desktop-dashboard
      self.modules.nixos.desktop-notifications
      self.modules.nixos.desktop-screensaver
      self.modules.nixos.desktop-nightlight
      self.modules.nixos.desktop-audio
      self.modules.nixos.desktop-clipboard
      self.modules.nixos.desktop-menu
      self.modules.nixos.desktop-plugins

      self.modules.nixos.desktop-binds
      self.modules.nixos.desktop-autostart
      self.modules.nixos.desktop-input
      self.modules.nixos.desktop-login
      self.modules.nixos.desktop-controlcenter
      self.modules.nixos.desktop-gestures
      self.modules.nixos.desktop-launcher

      self.modules.nixos.applications-applist
      self.modules.nixos.applications-appimage
      self.modules.nixos.applications-appimage-raven
      self.modules.nixos.desktop-dux-tools
      self.modules.nixos.applications-screenshot
      self.modules.nixos.applications-browser
      self.modules.nixos.applications-git
      self.modules.nixos.applications-kdeconnect
      self.modules.nixos.applications-multimedia
      self.modules.nixos.applications-office
      self.modules.nixos.applications-obsidian
      self.modules.nixos.applications-steam
      self.modules.nixos.applications-terminal
      self.modules.nixos.applications-vesktop
    ]
    ++ (
      if builtins.pathExists ./00-hardware-quirks.nix then
        [ self.modules.nixos.system-hardware-quirks ]
      else
        [ ]
    );

    home-manager.sharedModules = [
      self.modules.homeManager.stylix-colors
      self.modules.homeManager.users-user-editor
      self.modules.homeManager.applications-browser
      self.modules.homeManager.applications-multimedia-player
      self.modules.homeManager.applications-obsidian
      self.modules.homeManager.applications-vesktop
      self.modules.homeManager.applications-terminal-ghostty
      self.modules.homeManager.applications-terminal-btop
      self.modules.homeManager.applications-terminal-tuis
      self.modules.homeManager.applications-terminal-fastfetch
      self.modules.homeManager.desktop-screensaver
      self.modules.homeManager.applications-webapps
      self.modules.homeManager.dux-tools
      self.modules.homeManager.first-boot
    ];

  };

}
