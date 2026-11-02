/*
  @menu
  displayname = "Display";
  icon = "preferences-desktop-display-symbolic";
  order = 10;
  description = "Monitors, tearing and HDR";
  category = "02-Core";
*/

{ self, inputs, ... }: {

  flake.modules.nixos.desktop-display =
    { config, lib, ... }:

    let
      flagDefaults = {
        xwayland_ignore_scale = false;
      };

      enumSpecs = {
        allow_tearing = {
          default = "disable";
          choices = {
            "disable" = 0;
            "enable" = 1;
            "fullscreen-only" = 2;
          };
        };
        hdr_depth = {
          default = "hdr10";
          choices = {
            "default" = 0;
            "hdr8" = 1;
            "hdr10" = 2;
          };
        };
      };

      iccProfile = config.ojuny.accessibility.iccProfile;

      withIcc =
        rule:
        rule
        // lib.optionalAttrs (iccProfile != null) {
          icc = toString iccProfile;
        };
    in
    {

      options.ojuny.mango.flag = lib.mapAttrs (
        name: default:
        lib.mkOption {
          type = lib.types.bool;
          inherit default;
          description = "mango global ${name}, stored as 0/1.";
        }
      ) flagDefaults;

      options.ojuny.mango.enum = lib.mapAttrs (
        name: spec:
        lib.mkOption {
          type = lib.types.enum (lib.attrNames spec.choices);
          default = spec.default;
          description = "mango global ${name}.";
        }
      ) enumSpecs;

      config = {

        # Monitors
        # @option widget = "monitors"; label = "Monitors"; group = "Monitors"; groupOrder = 10; description = "Drag monitors to set their position; sizes and names stay editable in the rule.";
        desktop.ojuny.mango.rules.monitor_rule = map withIcc [
          {
            name = "eDP-1";
            width = 1920;
            height = 1080;
            refresh = 60;
            x = 0;
            y = 0;
            scale = 1.00;
            rr = 0;
          }
          {
            name = "HDMI-A-1";
            width = 1920;
            height = 1080;
            refresh = 60;
            x = 1920;
            y = 0;
            scale = 1.00;
            rr = 1;
          }
        ];

        # Tearing and HDR
        # @option widget = "dropdown"; label = "Allow tearing"; group = "Tearing and HDR"; groupOrder = 20; choices = [ "disable" "enable" "fullscreen-only" ]; applyCommand = "case %%val%% in disable) v=0;; enable) v=1;; fullscreen-only) v=2;; esac; mmsg dispatch setoption,allow_tearing,$v";
        ojuny.mango.enum.allow_tearing = "disable";

        # @option widget = "dropdown"; label = "HDR depth"; group = "Tearing and HDR"; groupOrder = 20; choices = [ "default" "hdr8" "hdr10" ]; description = "Requires HDR in the monitor rule and the Vulkan renderer."; applyCommand = "case %%val%% in default) v=0;; hdr8) v=1;; hdr10) v=2;; esac; mmsg dispatch setoption,hdr_depth,$v";
        ojuny.mango.enum.hdr_depth = "hdr10";

        # @option widget = "switch"; label = "Do not scale XWayland"; group = "Tearing and HDR"; groupOrder = 20; applyCommand = "mmsg dispatch setoption,xwayland_ignore_scale,$(case %%val%% in true) echo 1;; *) echo 0;; esac)";
        ojuny.mango.flag.xwayland_ignore_scale = false;

        # Gamma and contrast
        # @option widget = "slider"; label = "Gamma"; group = "Gamma and contrast"; groupOrder = 40; min = 0.5; max = 2.0; step = 0.05; description = "Panel gamma, 1.0 is neutral. Requires DMS API v34+."; applyCommand = "dms ipc call night gamma %%val%%";
        desktop.ojuny.dux.session.displayGamma = 1.0;

        # @option widget = "slider"; label = "Contrast"; group = "Gamma and contrast"; groupOrder = 40; min = 0.5; max = 2.0; step = 0.05; description = "Panel contrast, 1.0 is neutral. Requires DMS API v34+."; applyCommand = "dms ipc call night contrast %%val%%";
        desktop.ojuny.dux.session.displayContrast = 1.0;

        # Derived mango integers (no @option, hidden in the GUI).
        desktop.ojuny.mango.global.xwayland_ignore_scale =
          if config.ojuny.mango.flag.xwayland_ignore_scale then 1 else 0;
        desktop.ojuny.mango.global.allow_tearing =
          enumSpecs.allow_tearing.choices.${config.ojuny.mango.enum.allow_tearing};
        desktop.ojuny.mango.global.hdr_depth =
          enumSpecs.hdr_depth.choices.${config.ojuny.mango.enum.hdr_depth};
      };
    };

}
