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
        /* @option widget = "dropdown"; label = "Hardware profile";
           description = "auto reads the generated facter.json. Apply with: nix run .#regenerate-hardware -- --profile-only";
           choices = [
             "auto"
             "apple-macbook-air-3" "apple-macbook-air-4" "apple-macbook-air-5" "apple-macbook-pro" "apple-macmini-4-1"
             "asus-ally-rc71l" "asus-fa506nc" "asus-fa507nv" "asus-flow-gv302x-amdgpu" "asus-flow-gv302x-nvidia"
             "asus-flow-gz301vu" "asus-fx506hm" "asus-pro-ws-x570-ace" "asus-proart-px13" "asus-proart-px13-hn7306eac"
             "asus-rog-gl552vw" "asus-rog-strix-g513im" "asus-rog-strix-g533q" "asus-rog-strix-g533zw" "asus-rog-strix-g713ie"
             "asus-rog-strix-g733qs" "asus-rog-strix-x570e" "asus-zenbook-ux371" "asus-zenbook-ux535" "asus-zephyrus-ga401"
             "asus-zephyrus-ga401iv" "asus-zephyrus-ga402" "asus-zephyrus-ga402x-amdgpu" "asus-zephyrus-ga402x-nvidia" "asus-zephyrus-ga502"
             "asus-zephyrus-ga503" "asus-zephyrus-gu603h" "asus-zephyrus-gu605cw" "asus-zephyrus-gu605my" "chuwi-minibook-x"
             "dell-latitude-7420" "dell-latitude-7430" "dell-latitude-7490" "dell-precision-5560" "dell-precision-5570"
             "dell-xps-13-7390" "dell-xps-13-9300" "dell-xps-13-9310" "dell-xps-13-9315" "dell-xps-13-9333"
             "dell-xps-13-9343" "dell-xps-13-9350" "dell-xps-13-9360" "dell-xps-13-9370" "dell-xps-13-9380"
             "dell-xps-15-7590" "dell-xps-15-7590-nvidia" "dell-xps-15-9500" "dell-xps-15-9500-nvidia" "dell-xps-15-9510"
             "dell-xps-15-9510-nvidia" "dell-xps-15-9520" "dell-xps-15-9520-nvidia" "dell-xps-15-9530" "dell-xps-15-9530-nvidia"
             "dell-xps-15-9550" "dell-xps-15-9550-nvidia" "dell-xps-15-9560-intel" "dell-xps-15-9560-nvidia" "dell-xps-15-9570-intel"
             "dell-xps-15-9570-nvidia" "dell-xps-17-9700-intel" "dell-xps-17-9700-nvidia" "dell-xps-17-9710-intel" "framework-11th-gen-intel"
             "framework-12-13th-gen-intel" "framework-12th-gen-intel" "framework-13-7040-amd" "framework-13th-gen-intel" "framework-16-7040-amd"
             "framework-16-amd-ai-300-series" "framework-16-amd-ai-300-series-nvidia" "framework-amd-ai-300-series" "framework-desktop-amd-ai-max-300-series" "framework-intel-core-ultra-series1"
             "framework-intel-core-ultra-series3" "gigabyte-b550" "gigabyte-b650" "google-brya" "google-pixelbook"
             "google-rex" "gpd-pocket-3" "gpd-pocket-4" "gpd-win-2" "gpd-win-max-2-2023"
             "gpd-win-mini-2024" "hp-elitebook-830g6" "hp-elitebook-845g7" "hp-elitebook-845g8" "hp-elitebook-845g9"
             "hp-laptop-14s-dq2024nf" "hp-laptop-15s-fq1xxx" "hp-probook-440G5" "hp-probook-460G11" "huawei-machc-wa"
             "intel-nuc-12wshi7" "lenovo-ideapad-15ach6" "lenovo-legion-15ach6h" "lenovo-thinkpad-t14-intel-gen1" "lenovo-thinkpad-t14s"
             "lenovo-thinkpad-x1" "lenovo-thinkpad-x1-10th-gen" "lenovo-thinkpad-x1-11th-gen" "lenovo-thinkpad-x1-7th-gen" "lenovo-thinkpad-x1-9th-gen"
             "lenovo-thinkpad-x13-intel" "lenovo-yoga-6-13ALC6" "lenovo-yoga-7-14ARH7-amdgpu" "lenovo-yoga-7-14ARH7-nvidia" "letsnote-cf-lx3"
             "letsnote-cf-lx4" "microsoft-surface-go" "microsoft-surface-laptop-amd" "microsoft-surface-pro-3" "microsoft-surface-pro-9"
             "microsoft-surface-pro-intel" "msi-b550-tomahawk" "msi-gf63" "msi-gl62" "msi-gl65-10SDR-492"
             "msi-gs60" "msi-prestige-15-a10sc" "ojuny-asus-expertbook-b9406" "ojuny-asus-rog-z13-gz302" "ojuny-asus-zenbook-ux5406aa"
             "ojuny-lenovo-yoga-pro-7-14iah10" "omen-14-fb0798ng" "omen-16-n0005ne" "purism-librem-13v3" "purism-librem-15v3"
             "razer-blade-14-RZ09-0530" "slimbook-hero-rpl-rtx" "starlabs-starlite-i5" "system76" "system76-darp6"
             "system76-galp5-1650" "system76-gaze18" "system76-thelio-mega" "tuxedo-aura-15-gen1" "tuxedo-infinitybook-pro14-gen10-amd"
             "tuxedo-infinitybook-pro14-gen9-amd" "tuxedo-infinitybook-pro14-gen9-intel" "tuxedo-infinitybook-pro15-gen10-amd" "tuxedo-pulse-14-gen3" "tuxedo-pulse-15-gen2"
             "xiaomi-redmibook-15-pro-2021" "xiaomi-redmibook-16-pro-2024"
           ]; */
        ojuny.hardware.profile = "auto";

        # @option widget = "text"; label = "Detected model"; readonly = true;
        ojuny.hardware.detectedModel = lib.mkDefault "";

        # @option widget = "text"; label = "Detected profile"; readonly = true;
        ojuny.hardware.detectedProfile = lib.mkDefault "";

        # @option widget = "text"; label = "Coverage state"; readonly = true;
        ojuny.hardware.detectedState = lib.mkDefault "";

        # @option widget = "text"; label = "Effective GPU"; readonly = true;
        ojuny.hardware.gpu.detected = layout;

        # @option widget = "switch"; label = "Profile owns GPU settings"; readonly = true;
        ojuny.hardware.gpu.managed = managed;

        # @option widget = "text"; label = "GPU source"; readonly = true;
        ojuny.hardware.gpu.source = source;

        ojuny.hardware.gpu.busIds = detection.gpu.busIds;

        hardware.facter.reportPath = lib.mkIf (builtins.pathExists ./facter.json) ./facter.json;
      };
    };
}
