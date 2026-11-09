/*
  @menu
  displayname = "Hardware profile";
  icon = "computer-symbolic";
  order = 46;
  description = "Detected hardware and nixos-hardware profile. Coverage: docs/hardware-coverage.md. Apply a change with: nix run .#regenerate-hardware -- --profile-only";
  category = "07-System";
  hidden = false;
*/

{ self, ... }:

{
  flake.modules.nixos.system-facter =
    { config, lib, ... }:
    let
      detection = self.lib.hardware-detection;
      gpuProfiles = self.lib.hardware-gpu-profiles;
      gpuProfileBase = self.lib.hardware-gpu-profile-base;
      selected =
        if config.ojuny.hardware.profile == "auto" then
          detection.profile
        else
          config.ojuny.hardware.profile;
      base =
        if config.ojuny.hardware.profile == "auto" then
          detection.baseProfile
        else
          (gpuProfileBase.${selected} or selected);
      meta = gpuProfiles.${base} or null;
      variants = if meta == null then [ ] else meta.variants;
      selectedVariant = lib.findFirst (variant: (variant.profile or "") == selected) null variants;
      layout =
        if config.ojuny.hardware.profile == "auto" then
          detection.gpu.layout
        else if selectedVariant != null then
          selectedVariant.layout
        else if variants != [ ] then
          (lib.head variants).layout
        else
          detection.gpu.layout;
      managed = if meta == null then false else (meta.owns or false);
      source =
        if config.ojuny.hardware.profile == "auto" || meta == null then
          detection.gpu.source
        else
          "profile";
    in
    {
      options.ojuny.hardware.profile = lib.mkOption {
        type = lib.types.str;
        default = "auto";
        description = "nixos-hardware profile written to 00-hardware-quirks.nix, or auto to select from facter.json.";
      };

      options.ojuny.hardware.gpu = {
        detected = lib.mkOption {
          type = lib.types.enum [
            "intel"
            "amd"
            "nvidia"
            "hybrid-intel-nvidia"
            "hybrid-amd-nvidia"
            "hybrid-intel-amd"
            "none"
            "unknown"
          ];
          default = "unknown";
          description = "Effective GPU layout from the facter report or the selected profile.";
        };
        managed = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Whether the selected nixos-hardware profile owns the GPU settings.";
        };
        source = lib.mkOption {
          type = lib.types.enum [ "facter" "profile" "unknown" ];
          default = "unknown";
          description = "Where the effective GPU layout came from.";
        };
        busIds = {
          intel = lib.mkOption { type = lib.types.str; default = "PCI:0:2:0"; };
          amd = lib.mkOption { type = lib.types.str; default = "PCI:5:0:0"; };
          nvidia = lib.mkOption { type = lib.types.str; default = "PCI:1:0:0"; };
          discrete = lib.mkOption { type = lib.types.str; default = "PCI:5:0:0"; };
        };
      };

      config = {
        # @option widget = "facter"; label = "Hardware profile"; description = "Reads the generated facter.json and shows the detected model, profile, coverage state and effective GPU. Apply a profile change with: nix run .#regenerate-hardware -- --profile-only";
        ojuny.hardware.profile = "auto";

        ojuny.hardware.detectedModel = lib.mkDefault "";
        ojuny.hardware.detectedProfile = lib.mkDefault "";
        ojuny.hardware.detectedState = lib.mkDefault "";

        ojuny.hardware.gpu.detected = layout;
        ojuny.hardware.gpu.managed = managed;
        ojuny.hardware.gpu.source = source;

        ojuny.hardware.gpu.busIds = detection.gpu.busIds;

        hardware.facter.reportPath = lib.mkIf (builtins.pathExists ./facter.json) ./facter.json;
      };
    };
}
