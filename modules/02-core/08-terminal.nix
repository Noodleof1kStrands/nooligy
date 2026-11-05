/*
  @menu
  displayname = "Terminal";
  icon = "utilities-terminal-symbolic";
  order = 80;
  description = "Terminal emulator and multiplexer";
  category = "02-Core";
*/

{ self, inputs, ... }: {

  flake.modules.nixos.applications-terminal =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {

      options.ojuny.apps.terminal = {
        enable = lib.mkEnableOption "the terminal application set";

        aliases = lib.mkOption {
          type = lib.types.attrsOf (
            lib.types.submodule {
              options = {
                enable = lib.mkOption {
                  type = lib.types.bool;
                  default = true;
                  description = "Enable this alias.";
                };
                value = lib.mkOption {
                  type = lib.types.str;
                  description = "Command the alias expands to.";
                };
              };
            }
          );
          default = { };
          description = "Shell aliases keyed by name, converted to environment.shellAliases.";
        };

        p10k = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Load the powerlevel10k prompt theme.";
        };

        fastfetch = {
          customLogo = lib.mkOption {
            type = lib.types.bool;
            default = false;
            description = "Use a custom image for the fastfetch logo.";
          };

          customLogoPath = lib.mkOption {
            type = lib.types.nullOr lib.types.path;
            default = null;
            description = "Path to the image used as the fastfetch logo when customLogo is enabled.";
          };
        };
      };

      config = {
        ojuny.apps.terminal.enable = true;

        # @option widget = "switch"; label = "Powerlevel10k prompt"; group = "Shell"; groupOrder = 20; order = 5; description = "Load the powerlevel10k prompt theme. The package stays installed when disabled.";
        ojuny.apps.terminal.p10k = true;

        # @option widget = "switch"; label = "Custom fastfetch logo"; group = "Fastfetch"; groupOrder = 25; order = 10; description = "Use a custom image for the fastfetch logo instead of the default NixOS logo.";
        ojuny.apps.terminal.fastfetch.customLogo = false;

        # @option widget = "file"; fileDir = "./logos"; fileExtensions = [ ".png" ".jpg" ".jpeg" ".webp" ]; label = "Fastfetch logo image"; group = "Fastfetch"; groupOrder = 25; order = 20; nullable = true; visibleWhen.path = "ojuny.apps.terminal.fastfetch.customLogo"; visibleWhen.equals = true; description = "Image used as the fastfetch logo. Only used when the custom logo switch is on.";
        ojuny.apps.terminal.fastfetch.customLogoPath = null;

        # @option widget = "packages"; label = "Packages"; group = "Packages"; groupOrder = 30; description = "Multiplexers, shell prompt and command line tools.";
        environment.systemPackages = with pkgs; [
          zellij
          tmux
          zsh-powerlevel10k
          zoxide
          eza
          fzf
          bat
          fastfetch
        ];

        # Shell
        programs.zsh.enable = lib.any (
          user:
          let
            shell = user.shell or pkgs.bash;
          in
          shell != null && lib.getName shell == "zsh"
        ) (lib.attrValues config.users.users);

        # @option widget = "switch"; label = "Autosuggestions"; group = "Shell"; groupOrder = 20; order = 10; visibleWhen.path = "programs.zsh.enable"; visibleWhen.equals = true;
        programs.zsh.autosuggestions.enable = true;

        # @option widget = "switch"; label = "Async suggestions"; group = "Shell"; order = 20; visibleWhen.path = "programs.zsh.autosuggestions.enable"; visibleWhen.equals = true;
        programs.zsh.autosuggestions.async = true;

        # @option widget = "switch"; label = "Syntax highlighting"; group = "Shell"; order = 30; visibleWhen.path = "programs.zsh.enable"; visibleWhen.equals = true;
        programs.zsh.syntaxHighlighting.enable = true;

        # @option widget = "switch"; label = "oh-my-zsh"; group = "Shell"; order = 40; visibleWhen.path = "programs.zsh.enable"; visibleWhen.equals = true;
        programs.zsh.ohMyZsh.enable = true;

        # @option widget = "list"; label = "oh-my-zsh plugins"; group = "Shell"; order = 50; visibleWhen.path = "programs.zsh.ohMyZsh.enable"; visibleWhen.equals = true;
        programs.zsh.ohMyZsh.plugins = [
          "git"
          "sudo"
        ];

        # @option widget = "spin"; label = "History size"; group = "Shell"; order = 60; step = 1000; unit = "lines"; visibleWhen.path = "programs.zsh.enable"; visibleWhen.equals = true;
        programs.zsh.histSize = 10000;

        programs.zsh.promptInit = ''
          nixupdatesrc=${
            builtins.path {
              name = "nixupdate.sh";
              path = ./terminal/nixupdate.sh;
            }
          }
          ${lib.optionalString config.ojuny.apps.terminal.p10k "source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme"}
          source ${
            builtins.path {
              name = "config.zsh";
              path = ./terminal/config.zsh;
            }
          }
          source ${
            builtins.path {
              name = "functions.zsh";
              path = ./terminal/functions.zsh;
            }
          }
          ${lib.optionalString config.ojuny.apps.terminal.p10k "POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true"}
        '';

        programs.zsh.interactiveShellInit = ''
          eval "$(zoxide init --cmd cd zsh)"
          source <(fzf --zsh)
          if [ "$TERM_PROGRAM" != "vscode" ]; then
            if which fastfetch 2>&1 > /dev/null; then fastfetch; else nix-shell -p fastfetch --run "fastfetch"; fi
          fi
        '';

        # Aliases
        # @option widget = "table-attrset"; label = "Aliases"; group = "Aliases"; groupOrder = 50; columns = [ "enable" "value" ]; columnTypes = [ "bool" "str" ];
        ojuny.apps.terminal.aliases = {
          # @table-item label = "ls";
          ls = {
            enable = true;
            value = "eza -al --color=always --group-directories-first --icons=always";
          };
          # @table-item label = "la";
          la = {
            enable = true;
            value = "eza -a --color=always --group-directories-first --icons=always";
          };
          # @table-item label = "ll";
          ll = {
            enable = true;
            value = "eza -l --color=always --group-directories-first --icons=always";
          };
          # @table-item label = "lt";
          lt = {
            enable = true;
            value = "eza -aT --level=4 --color=always --group-directories-first --icons=always";
          };
          # @table-item label = "l.";
          "l." = {
            enable = true;
            value = "eza -a | grep -e '^\\.'";
          };
          # @table-item label = "reloaddux";
          reloaddux = {
            enable = true;
            value = "dms kill && mmsg dispatch spawn_shell,dms run";
          };
          # @table-item label = "reloaddms";
          reloaddms = {
            enable = true;
            value = "dms kill && mmsg dispatch spawn_shell,dms run";
          };
          # @table-item label = "find";
          find = {
            enable = true;
            value = "fzf --layout=reverse --preview='bat {}'";
          };
          # @table-item label = "..";
          ".." = {
            enable = true;
            value = "cd ..";
          };
          # @table-item label = "...";
          "..." = {
            enable = true;
            value = "cd ../..";
          };
          # @table-item label = "....";
          "...." = {
            enable = true;
            value = "cd ../../..";
          };
          # @table-item label = ".....";
          "....." = {
            enable = true;
            value = "cd ../../../..";
          };
          # @table-item label = "......";
          "......" = {
            enable = true;
            value = "cd ../../../../..";
          };
          # @table-item label = "dir";
          dir = {
            enable = true;
            value = "dir --color=auto";
          };
          # @table-item label = "vdir";
          vdir = {
            enable = true;
            value = "vdir --color=auto";
          };
          # @table-item label = "grep";
          grep = {
            enable = true;
            value = "grep --color=auto";
          };
          # @table-item label = "fgrep";
          fgrep = {
            enable = true;
            value = "fgrep --color=auto";
          };
          # @table-item label = "egrep";
          egrep = {
            enable = true;
            value = "egrep --color=auto";
          };
        };

        # Derived, no @option: enabled rows become shell aliases; nixupdate stays fixed.
        environment.shellAliases =
          lib.mapAttrs (_: entry: entry.value) (
            lib.filterAttrs (_: entry: entry.enable) config.ojuny.apps.terminal.aliases
          )
          // {
            nixupdate = "${builtins.path {
              name = "nixupdate.sh";
              path = ./terminal/nixupdate.sh;
            }}";
          };

        # Multiplexer
        # @option widget = "dropdown"; label = "Type"; group = "Multiplexer"; groupOrder = 58; order = 10; choices = [ "tmux" "zellij" "herdr" ]; description = "Backend used by the session list."; applyCommand = "dms ipc call settings set muxType %%val%%";
        desktop.ojuny.dux.settings.muxType = "tmux";

        # @option widget = "switch"; label = "Use custom command"; group = "Multiplexer"; groupOrder = 58; order = 20; applyCommand = "dms ipc call settings set muxUseCustomCommand %%val%%";
        desktop.ojuny.dux.settings.muxUseCustomCommand = false;

        # @option widget = "text"; label = "Custom command"; group = "Multiplexer"; groupOrder = 58; order = 30; visibleWhen.path = "desktop.ojuny.dux.settings.muxUseCustomCommand"; visibleWhen.equals = true; description = "Receives the session name as the first argument."; applyCommand = "dms ipc call settings set muxCustomCommand %%val%%";
        desktop.ojuny.dux.settings.muxCustomCommand = "";

        # @option widget = "text"; label = "Session filter"; group = "Multiplexer"; groupOrder = 58; order = 40; description = "Comma-separated session names to hide. Wrap in slashes for regex."; applyCommand = "dms ipc call settings set muxSessionFilter %%val%%";
        desktop.ojuny.dux.settings.muxSessionFilter = "";

      };
    };

  flake.modules.homeManager.applications-terminal-btop =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      # @option widget = "switch"; label = "enable btop"; group = "btop"; groupOrder = 55;
      programs.btop.enable = true;
    };

  # Ghostty is installed and configured through home-manager, gated by the
  # system switch above. Every leaf carries an @option so the settings GUI can
  # render and edit it.
  flake.modules.homeManager.applications-terminal-ghostty =
    {
      config,
      lib,
      pkgs,
      osConfig ? { },
      ...
    }:
    {
      config = lib.mkIf (osConfig.ojuny.apps.terminal.enable or false) {
        programs.ghostty = {
          # Derived, no @option: mirrors the system switch.
          enable = true;

          # @option widget = "switch"; label = "bat syntax"; group = "Ghostty"; groupOrder = 60;
          installBatSyntax = true;

          # @option widget = "switch"; label = "zsh integration"; group = "Ghostty";
          enableZshIntegration = true;

          # @option widget = "switch"; label = "Keep default keybinds"; group = "Ghostty";
          clearDefaultKeybinds = false;

          # @option widget = "switch"; label = "systemd service"; group = "Ghostty";
          systemd.enable = true;

          settings = {
            # @option widget = "text"; label = "Command"; group = "Ghostty"; hidden = true;
            command =
              let
                shell = osConfig.users.users.${config.home.username}.shell or pkgs.zsh;
              in
              "${shell}/bin/${lib.getName shell}";

            # @option widget = "spin"; label = "Scrollback limit"; group = "Ghostty"; min = 0; max = 2000000000; unit = "lines";
            scrollback-limit = 1048576000;

            # @option widget = "slider"; label = "Background opacity"; group = "Ghostty"; min = 0.0; max = 1.0; step = 0.05;
            background-opacity = 0.5;

            # @option widget = "switch"; label = "Clickable links"; group = "Ghostty";
            link-url = true;

            # @option widget = "switch"; label = "Link previews"; group = "Ghostty";
            link-previews = true;

            # @option widget = "switch"; label = "Focus follows mouse"; group = "Ghostty";
            focus-follows-mouse = true;

            # @option widget = "switch"; label = "New windows start in home"; group = "Ghostty";
            window-inherit-working-directory = false;

            # @option widget = "switch"; label = "New tabs inherit directory"; group = "Ghostty";
            tab-inherit-working-directory = true;

            # @option widget = "switch"; label = "New splits inherit directory"; group = "Ghostty";
            split-inherit-working-directory = true;

            # @option widget = "text"; label = "Font family"; group = "Ghostty";
            font-family = "CaskaydiaCove Nerd Font Mono";

            # @option widget = "dropdown"; label = "Window decoration"; group = "Ghostty"; choices = [ "auto" "client" "server" "none" ];
            window-decoration = "none";

            # @option widget = "switch"; label = "Confirm close"; group = "Ghostty";
            confirm-close-surface = false;

            # @option widget = "switch"; label = "GTK single instance"; group = "Ghostty";
            gtk-single-instance = false;

            # @option widget = "dropdown"; label = "Clipboard read"; group = "Ghostty"; choices = [ "ask" "allow" "deny" ];
            clipboard-read = "allow";

            # @option widget = "dropdown"; label = "Clipboard write"; group = "Ghostty"; choices = [ "ask" "allow" "deny" ];
            clipboard-write = "allow";

            # @option widget = "list"; label = "Keybindings"; group = "Ghostty";
            keybind = [
              "alt+up=new_split:up"
              "alt+down=new_split:down"
              "alt+left=new_split:left"
              "alt+right=new_split:right"
              "ctrl+alt+r=reload_config"
              "ctrl+shift+r=reset"
              "ctrl+shift+c=copy_to_clipboard"
              "ctrl+shift+v=paste_from_clipboard"
              "ctrl+a=select_all"
              "shift+left=adjust_selection:left"
              "shift+right=adjust_selection:right"
              "shift+up=adjust_selection:up"
              "shift+down=adjust_selection:down"
            ];
          };
        };
      };
    };

  flake.modules.homeManager.applications-terminal-fastfetch =
    {
      config,
      lib,
      pkgs,
      osConfig ? { },
      ...
    }:
    let
      colors = self.colors config.lib.stylix.colors;
      template = osConfig.ojuny.style.palette;
      fastfetch =
        osConfig.ojuny.apps.terminal.fastfetch or {
          customLogo = false;
          customLogoPath = null;
        };
    in
    {
      config = lib.mkIf (osConfig.ojuny.apps.terminal.enable or false) {
        programs.fastfetch = {
          enable = true;

          settings = lib.mkDefault {
            display = {
              separator = " ";
            };

            logo = {
              type = "auto";
              source =
                if fastfetch.customLogo && fastfetch.customLogoPath != null then
                  toString fastfetch.customLogoPath
                else
                  "nixos";
              width = 40;
              padding = {
                top = 0;
                left = 0;
                right = 2;
              };
              color = {
                "1" = colors.selectionBackground.hex;
                "2" = colors.variables.hex;
                "3" = colors.selectionBackground.hex;
                "4" = colors.classes.hex;
                "5" = colors.selectionBackground.hex;
                "6" = colors.functions.hex;
              };
            };

            modules = [
              {
                type = "title";
                keyWidth = 10;
              }
              "break"
              {
                type = "os";
                key = " OS";
                keyColor = colors.variables.hex;
              }
              {
                type = "custom";
                key = "├  Dotfiles";
                keyColor = colors.variables.hex;
                format = "Ojuny";
              }
              {
                type = "kernel";
                key = "├ Kernel";
                keyColor = colors.variables.hex;
              }
              {
                type = "packages";
                key = "├󰏖 Packages";
                keyColor = colors.variables.hex;
              }
              {
                type = "shell";
                key = "├ Shell";
                keyColor = colors.variables.hex;
              }
              {
                type = "localIP";
                key = "├󰩟 Local IP";
                keyColor = colors.variables.hex;
              }
              {
                type = "uptime";
                key = "└󰅐 Start Time";
                keyColor = colors.variables.hex;
              }
              "break"
              {
                type = "wm";
                key = "󰧨 Window Manager";
                keyColor = colors.classes.hex;
              }
              {
                type = "custom";
                key = "├󱂬 Desktop Shell";
                keyColor = colors.classes.hex;
                format = "Dux Modular Shell";
              }
              {
                type = "lm";
                key = "├󰧨 Login Manager";
                keyColor = colors.classes.hex;
              }
              {
                type = "wmtheme";
                key = "├󰉼 WM Theme";
                keyColor = colors.classes.hex;
              }
              {
                type = "theme";
                key = "├󰉼 Color Themes";
                keyColor = colors.classes.hex;
              }
              {
                type = "custom";
                key = "├󰉼Stylix Palette";
                keyColor = colors.classes.hex;
                format = "${template}";
              }
              {
                type = "icons";
                key = "├󰸉 System Icons";
                keyColor = colors.classes.hex;
              }
              {
                type = "terminal";
                key = "├ Terminal";
                keyColor = colors.classes.hex;
              }
              {
                type = "terminalfont";
                key = "└ Terminal Font";
                keyColor = colors.classes.hex;
              }
              "break"
              {
                type = "chassis";
                key = "󰌢 PC";
                keyColor = colors.functions.hex;
              }
              {
                type = "board";
                key = "├ Board";
                keyColor = colors.functions.hex;
              }
              {
                type = "cpu";
                key = "├󰻠 CPU";
                keyColor = colors.functions.hex;
                temp = true;
                freqNdigits = 1;
              }
              {
                type = "memory";
                key = "├󰑭 RAM";
                keyColor = colors.functions.hex;
                percent = {
                  type = 3;
                  green = 30;
                  yellow = 70;
                };
              }
              {
                type = "swap";
                key = "├󰓡 Zram";
                keyColor = colors.functions.hex;
                percent = {
                  type = 3;
                  green = 30;
                  yellow = 70;
                };
              }
              {
                type = "disk";
                key = "├ Disk";
                keyColor = colors.functions.hex;
                percent = {
                  type = 3;
                  green = 30;
                  yellow = 70;
                };
              }
              {
                type = "display";
                key = "├󰍹 Display(s)";
                keyColor = colors.functions.hex;
              }
              {
                type = "gpu";
                key = "├󰍛 GPU";
                keyColor = colors.functions.hex;
              }
              {
                type = "opengl";
                key = "├󰍛 OpenGL";
                keyColor = colors.functions.hex;
              }
              {
                type = "vulkan";
                key = "└󰍛 Vulkan";
                keyColor = colors.functions.hex;
              }
            ];
          };
        };
      };
    };

}
