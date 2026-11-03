/*
  @menu
  displayname = "Browser";
  icon = "web-browser-symbolic";
  order = 60;
  description = "Web browser and default browser";
  category = "02-Core";
*/

{ self, inputs, ... }: {

  flake.modules.nixos.applications-browser =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      browserDesktop =
        {
          firefox = "firefox.desktop";
          chrome = "google-chrome.desktop";
          brave = "brave-browser.desktop";
        }
        .${config.ojuny.browser.selected};

      browserCommand =
        {
          firefox = "firefox --new-window";
          chrome = "google-chrome-stable --new-window";
          brave = "brave --new-window";
        }
        .${config.ojuny.browser.selected};

      enabledSearchEngines = lib.filterAttrs (
        _: engine: engine.enable
      ) config.ojuny.browser.searchEngines;

      defaultSearchEngine =
        let
          engines = lib.attrValues enabledSearchEngines;
        in
        if engines == [ ] then
          null
        else
          lib.findFirst (engine: engine.isDefault) (lib.head engines) engines;

      searchEngineKeyword = alias: if lib.hasPrefix "@" alias then lib.removePrefix "@" alias else alias;

      toolbarBookmarks = lib.filter (bookmark: bookmark.toolbar) config.ojuny.browser.bookmarks;
      folderedBookmarks = lib.filter (
        bookmark: !bookmark.toolbar && bookmark.folder != ""
      ) config.ojuny.browser.bookmarks;
      topLevelBookmarks = lib.filter (
        bookmark: !bookmark.toolbar && bookmark.folder == ""
      ) config.ojuny.browser.bookmarks;

      bookmarksByFolder = lib.foldl' (
        folders: bookmark:
        folders
        // {
          ${bookmark.folder} = (folders.${bookmark.folder} or [ ]) ++ [ bookmark ];
        }
      ) { } folderedBookmarks;

      chromiumBookmark = bookmark: {
        inherit (bookmark) name url;
      };

      chromiumBookmarkFolders = lib.mapAttrsToList (folder: bookmarks: {
        name = folder;
        children = map chromiumBookmark bookmarks;
      }) bookmarksByFolder;

      chromiumPolicy =
        lib.optionalAttrs (defaultSearchEngine != null) {
          DefaultSearchProviderEnabled = true;
          DefaultSearchProviderName = defaultSearchEngine.name;
          DefaultSearchProviderSearchURL = defaultSearchEngine.searchUrl;
          DefaultSearchProviderEncodings = [ "UTF-8" ];
        }
        // lib.optionalAttrs (defaultSearchEngine != null && defaultSearchEngine.alias != "") {
          DefaultSearchProviderKeyword = searchEngineKeyword defaultSearchEngine.alias;
        }
        // lib.optionalAttrs (config.ojuny.browser.bookmarks != [ ]) {
          ManagedBookmarks = [
            { toplevel_name = "Managed bookmarks"; }
          ]
          ++ map chromiumBookmark topLevelBookmarks
          ++ chromiumBookmarkFolders
          ++ lib.optional (toolbarBookmarks != [ ]) {
            name = "Bookmarks Toolbar";
            children = map chromiumBookmark toolbarBookmarks;
          };
        }
        // lib.optionalAttrs (toolbarBookmarks != [ ]) {
          BookmarkBarEnabled = true;
        };

      chromePoliciesEnabled =
        config.ojuny.browser.selected == "chrome"
        && config.ojuny.browser.chrome.enable
        && chromiumPolicy != { };
      bravePoliciesEnabled =
        config.ojuny.browser.selected == "brave"
        && config.ojuny.browser.brave.enable
        && chromiumPolicy != { };
    in
    {

      options.ojuny.browser.command = lib.mkOption {
        type = lib.types.str;
        internal = true;
        default = browserCommand;
        description = "Command used by the browser keybind for the selected browser.";
      };

      options.ojuny.browser.selected = lib.mkOption {
        type = lib.types.enum [
          "firefox"
          "chrome"
          "brave"
        ];
        default = "firefox";
        description = "Browser used for web and document links.";
      };

      options.ojuny.browser.chrome.savePasswords = lib.mkEnableOption "saving passwords in Chrome";

      options.ojuny.browser.brave.savePasswords = lib.mkEnableOption "saving passwords in Brave";

      options.ojuny.browser.searchEngines = lib.mkOption {
        type = lib.types.attrsOf (
          lib.types.submodule (
            { name, ... }:
            {
              options = {
                enable = lib.mkOption {
                  type = lib.types.bool;
                  default = true;
                  description = "Enable this search engine.";
                };
                name = lib.mkOption {
                  type = lib.types.nonEmptyStr;
                  default = name;
                  description = "Search engine display name.";
                };
                searchUrl = lib.mkOption {
                  type = lib.types.nonEmptyStr;
                  description = "Search URL template containing {searchTerms}.";
                };
                alias = lib.mkOption {
                  type = lib.types.str;
                  default = "";
                  description = "Search alias. Firefox receives it with a leading @, Chromium without.";
                };
                isDefault = lib.mkOption {
                  type = lib.types.bool;
                  default = false;
                  description = "Use this engine as the single Chrome or Brave default. Firefox keeps its own Search engine option.";
                };
              };
            }
          )
        );
        default = { };
        description = "Custom search engines keyed by id. Firefox installs every enabled row. Chrome and Brave use the isDefault row, or the first row.";
      };

      options.ojuny.browser.bookmarks = lib.mkOption {
        type = lib.types.listOf (
          lib.types.submodule {
            options = {
              name = lib.mkOption {
                type = lib.types.nonEmptyStr;
                description = "Bookmark name.";
              };
              url = lib.mkOption {
                type = lib.types.nonEmptyStr;
                description = "Bookmark URL.";
              };
              folder = lib.mkOption {
                type = lib.types.str;
                default = "";
                description = "Folder name. Empty keeps the bookmark at the top level.";
              };
              toolbar = lib.mkOption {
                type = lib.types.bool;
                default = false;
                description = "Place the bookmark in the Firefox bookmarks toolbar. Chromium browsers only enable the bookmarks bar.";
              };
            };
          }
        );
        default = [ ];
        description = "Bookmarks written to Firefox and to the selected Chromium browser's managed policies.";
      };

      options.ojuny.browser.chromiumExtensions = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [
          "cjpalhdlnbpafiamejdnhcphjbkeiagm"
          "mnjggcdmjocbbbhaepdhchncahnbgone"
        ];
        description = "Chromium, Chrome, and Brave extension IDs installed through the ExtensionInstallForcelist policy.";
      };

      options.ojuny.browser.firefox.autoEnableExtensions = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Set extensions.autoDisableScopes to 0 so packaged Firefox extensions are enabled on first launch.";
      };

      options.ojuny.browser.firefox.stylixColorTheme = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Apply the Stylix Firefox color theme to the default profile.";
      };

      options.ojuny.browser.firefox.extensions = lib.mkOption {
        type = lib.types.listOf lib.types.package;
        default = [ ];
        description = "Firefox extensions installed into the default profile.";
      };

      options.ojuny.browser.chromiumStylix = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Apply the Stylix Chromium theme color policy to Chromium, Chrome, and Brave.";
      };

      options.ojuny.browser.defaults = {
        html = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "the selected browser as default for HTML files";
        };
        http = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "the selected browser as default for HTTP links";
        };
        https = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "the selected browser as default for HTTPS links";
        };
        pdf = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "the selected browser as default for PDF documents";
        };
        png = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "the selected browser as default for PNG images";
        };
        mailto = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "the selected browser as default for email links";
        };
      };

      imports = [
        self.modules.nixos.chrome
        self.modules.nixos.brave
      ];
      config = {
        # The profile settings below live in home-manager, which uses the system
        # package set, so the addon overlay has to be registered here.
        nixpkgs.overlays = [ inputs.firefox-addons.overlays.default ];

        # @option widget = "dropdown"; label = "Default browser"; group = "Browser"; groupOrder = 10; order = 1; choices = [ "firefox" "chrome" "brave" ]; applyCommand = "case %%val%% in firefox) b=firefox.desktop;; chrome) b=google-chrome.desktop;; brave) b=brave-browser.desktop;; esac; xdg-mime default \"$b\" text/html; xdg-mime default \"$b\" x-scheme-handler/http; xdg-mime default \"$b\" x-scheme-handler/https";
        ojuny.browser.selected = "firefox";

        # @option widget = "table-attrset"; label = "Search engines"; group = "Search and bookmarks"; groupOrder = 60; order = 1; columns = [ "enable" "name" "searchUrl" "alias" "isDefault" ]; columnTypes = [ "bool" "str" "str" "str" "bool" ]; keyEditable = true; description = "Custom search engines. Firefox gets every enabled row. Chrome and Brave use the isDefault row, or the first row.";
        ojuny.browser.searchEngines = { };

        # @option widget = "table-list"; label = "Bookmarks"; group = "Search and bookmarks"; groupOrder = 60; order = 2; columns = [ "name" "url" "folder" "toolbar" ]; columnTypes = [ "str" "str" "str" "bool" ]; description = "Bookmarks written to Firefox and to Chrome or Brave managed policies. Folder groups bookmarks. Toolbar uses the Firefox toolbar and enables the Chromium bookmarks bar.";
        ojuny.browser.bookmarks = [ ];
        # @option widget = "list"; label = "Chrome/Brave extensions"; group = "Extensions"; groupOrder = 25; order = 10; itemLabel = "Extension ID"; addLabel = "Add extension"; visibleWhen.path = "ojuny.browser.selected"; visibleWhen.equals = [ "chrome" "brave" ]; description = "Chromium Web Store extension IDs installed through the ExtensionInstallForcelist policy for Chromium, Chrome, and Brave.";
        ojuny.browser.chromiumExtensions = [
          "cjpalhdlnbpafiamejdnhcphjbkeiagm"
          "mnjggcdmjocbbbhaepdhchncahnbgone"
        ];

        # @option widget = "switch"; label = "Enable Firefox"; group = "Firefox"; groupOrder = 20; order = 1; visibleWhen.path = "ojuny.browser.selected"; visibleWhen.equals = "firefox";
        programs.firefox.enable = true;

        # @option widget = "switch"; label = "Disable telemetry"; group = "Firefox"; order = 2; visibleWhen.path = "ojuny.browser.selected"; visibleWhen.equals = "firefox";
        programs.firefox.policies.DisableTelemetry = true;

        # @option widget = "switch"; label = "Block tracking cookies"; group = "Firefox"; order = 3; visibleWhen.path = "ojuny.browser.selected"; visibleWhen.equals = "firefox";
        programs.firefox.policies.EnableTrackingProtection = {
          Value = true;
        };

        # @option widget = "switch"; label = "Disable Firefox studies"; group = "Firefox"; order = 4; visibleWhen.path = "ojuny.browser.selected"; visibleWhen.equals = "firefox";
        programs.firefox.policies.DisableFirefoxStudies = true;

        # @option widget = "switch"; label = "Disable Pocket"; group = "Firefox"; order = 5; visibleWhen.path = "ojuny.browser.selected"; visibleWhen.equals = "firefox";
        programs.firefox.policies.DisablePocket = true;

        # @option widget = "switch"; label = "Offer to save logins"; group = "Firefox"; order = 6; visibleWhen.path = "ojuny.browser.selected"; visibleWhen.equals = "firefox";
        programs.firefox.policies.OfferToSaveLogins = false;

        # @option widget = "switch"; label = "Enable extensions automatically"; group = "Firefox"; order = 7; visibleWhen.path = "ojuny.browser.selected"; visibleWhen.equals = "firefox"; description = "Set extensions.autoDisableScopes to 0 so packaged Firefox extensions are enabled on first launch.";
        ojuny.browser.firefox.autoEnableExtensions = true;

        # @option widget = "switch"; label = "Stylix Firefox color theme"; group = "Firefox"; groupOrder = 20; order = 8; visibleWhen.path = "ojuny.browser.selected"; visibleWhen.equals = "firefox"; description = "Apply the Stylix Firefox color theme to the default profile. The profile name follows the Profile name field.";
        ojuny.browser.firefox.stylixColorTheme = true;

        # @option widget = "packages"; label = "Firefox extensions"; group = "Extensions"; groupOrder = 25; order = 20; description = "Firefox extensions installed into the profile. Available addons come from the firefox-addons input."; visibleWhen.path = "ojuny.browser.selected"; visibleWhen.equals = "firefox";
        ojuny.browser.firefox.extensions = with pkgs.firefox-addons; [
          ublock-origin
          sponsorblock
        ];

        # @option widget = "switch"; label = "Stylix Chromium theme"; group = "Chromium"; groupOrder = 25; order = 10; description = "Apply the Stylix Chromium theme color policy to Chromium, Chrome, and Brave.";
        ojuny.browser.chromiumStylix = true;

        # @option widget = "switch"; label = "Offer to save passwords"; group = "Chrome"; order = 2; visibleWhen.path = "ojuny.browser.selected"; visibleWhen.equals = "chrome";
        ojuny.browser.chrome.savePasswords = false;

        # @option widget = "switch"; label = "Offer to save passwords"; group = "Brave"; order = 2; visibleWhen.path = "ojuny.browser.selected"; visibleWhen.equals = "brave";
        ojuny.browser.brave.savePasswords = false;

        programs.chromium.enable = lib.mkDefault config.ojuny.browser.selected != "firefox";

        programs.chromium.defaultSearchProviderEnabled = config.ojuny.browser.selected != "firefox";

        programs.chromium.extensions = config.ojuny.browser.chromiumExtensions;

        stylix.targets.chromium.enable = config.ojuny.browser.chromiumStylix;

        programs.chromium.extraOpts =
          {
            firefox = { };
            chrome = {
              PasswordManagerEnabled = config.ojuny.browser.chrome.savePasswords;
            };
            brave = {
              PasswordManagerEnabled = config.ojuny.browser.brave.savePasswords;
            };
          }
          .${config.ojuny.browser.selected};

        environment.etc = lib.mkMerge [
          (lib.mkIf chromePoliciesEnabled {
            "opt/chrome/policies/managed/ojuny.json".text = builtins.toJSON chromiumPolicy;
          })
          (lib.mkIf bravePoliciesEnabled {
            "brave/policies/managed/ojuny.json".text = builtins.toJSON chromiumPolicy;
          })
        ];

        xdg.mime.enable = true;

        # @option widget = "switch"; label = "Set as default for HTML files"; group = "Default applications"; groupOrder = 50; order = 1; applyCommand = "v=$(xdg-settings get default-web-browser); [ -n \"$v\" ] && xdg-mime default \"$v\" text/html";
        xdg.mime.defaultApplications."text/html" =
          lib.mkIf config.ojuny.browser.defaults.html browserDesktop;

        # @option widget = "switch"; label = "Set as default for HTTP links"; group = "Default applications"; order = 2; applyCommand = "v=$(xdg-settings get default-web-browser); [ -n \"$v\" ] && xdg-mime default \"$v\" x-scheme-handler/http";
        xdg.mime.defaultApplications."x-scheme-handler/http" =
          lib.mkIf config.ojuny.browser.defaults.http browserDesktop;

        # @option widget = "switch"; label = "Set as default for HTTPS links"; group = "Default applications"; order = 3; applyCommand = "v=$(xdg-settings get default-web-browser); [ -n \"$v\" ] && xdg-mime default \"$v\" x-scheme-handler/https";
        xdg.mime.defaultApplications."x-scheme-handler/https" =
          lib.mkIf config.ojuny.browser.defaults.https browserDesktop;

        # @option widget = "switch"; label = "Set as default for PDF documents"; group = "Default applications"; order = 4; applyCommand = "v=$(xdg-settings get default-web-browser); [ -n \"$v\" ] && xdg-mime default \"$v\" application/pdf";
        xdg.mime.defaultApplications."application/pdf" =
          lib.mkIf config.ojuny.browser.defaults.pdf browserDesktop;

        # @option widget = "switch"; label = "Set as default for PNG images"; group = "Default applications"; order = 5; applyCommand = "v=$(xdg-settings get default-web-browser); [ -n \"$v\" ] && xdg-mime default \"$v\" image/png";
        xdg.mime.defaultApplications."image/png" =
          lib.mkIf config.ojuny.browser.defaults.png browserDesktop;

        # @option widget = "switch"; label = "Set as default for Email links"; group = "Default applications"; order = 6; applyCommand = "v=$(xdg-settings get default-web-browser); [ -n \"$v\" ] && xdg-mime default \"$v\" x-scheme-handler/mailto";
        xdg.mime.defaultApplications."x-scheme-handler/mailto" =
          lib.mkIf config.ojuny.browser.defaults.mailto browserDesktop;
      };

    };

  flake.modules.nixos.brave =
    {
      lib,
      pkgs,
      config,
      ...
    }:
    {

      options.ojuny.browser.brave.enable = lib.mkEnableOption "the Brave browser";
      config = {
        # @option widget = "switch"; label = "Enable Brave"; group = "Brave"; groupOrder = 40; order = 1; visibleWhen.path = "ojuny.browser.selected"; visibleWhen.equals = "brave";
        ojuny.browser.brave.enable = false;

        environment.systemPackages = lib.mkIf config.ojuny.browser.brave.enable [ pkgs.brave ];
      };
    };

  flake.modules.nixos.chrome =
    {
      lib,
      pkgs,
      config,
      ...
    }:
    {

      options.ojuny.browser.chrome.enable = lib.mkEnableOption "the Google Chrome browser";
      config = {
        # @option widget = "switch"; label = "Enable Chrome"; group = "Chrome"; groupOrder = 30; order = 1; visibleWhen.path = "ojuny.browser.selected"; visibleWhen.equals = "chrome";
        ojuny.browser.chrome.enable = false;

        environment.systemPackages = lib.mkIf config.ojuny.browser.chrome.enable [ pkgs.chrome ];
      };
    };

  # Profiles and extensions are home-manager territory; they ride on the same
  # page and are imported for every account through sharedModules. Gated by the
  # system Firefox switch so they only apply when the browser is enabled.
  flake.modules.homeManager.applications-browser =
    {
      config,
      lib,
      pkgs,
      osConfig ? { },
      ...
    }:
    let
      searchEngines = lib.filterAttrs (_: engine: engine.enable) (
        osConfig.ojuny.browser.searchEngines or { }
      );

      firefoxEngines = lib.mapAttrs (
        _: engine:
        {
          inherit (engine) name;
          urls = [ { template = engine.searchUrl; } ];
        }
        // lib.optionalAttrs (engine.alias != "") {
          definedAliases = [
            (if lib.hasPrefix "@" engine.alias then engine.alias else "@${engine.alias}")
          ];
        }
      ) searchEngines;

      bookmarks = osConfig.ojuny.browser.bookmarks or [ ];
      toolbarBookmarks = lib.filter (bookmark: bookmark.toolbar) bookmarks;
      folderedBookmarks = lib.filter (bookmark: !bookmark.toolbar && bookmark.folder != "") bookmarks;
      topLevelBookmarks = lib.filter (bookmark: !bookmark.toolbar && bookmark.folder == "") bookmarks;

      bookmarksByFolder = lib.foldl' (
        folders: bookmark:
        folders
        // {
          ${bookmark.folder} = (folders.${bookmark.folder} or [ ]) ++ [ bookmark ];
        }
      ) { } folderedBookmarks;

      firefoxBookmark = bookmark: {
        inherit (bookmark) name url;
      };

      firefoxBookmarkFolders = lib.mapAttrsToList (folder: items: {
        name = folder;
        bookmarks = map firefoxBookmark items;
      }) bookmarksByFolder;

      firefoxBookmarks =
        map firefoxBookmark topLevelBookmarks
        ++ firefoxBookmarkFolders
        ++ lib.optional (toolbarBookmarks != [ ]) {
          name = "Bookmarks Toolbar";
          toolbar = true;
          bookmarks = map firefoxBookmark toolbarBookmarks;
        };
    in
    {
      config = lib.mkIf (osConfig.programs.firefox.enable or false) {

        # @option widget = "text"; label = "Profile name"; group = "Firefox"; order = 10; description = "Name of the main profile on disk."; visibleWhen.path = "ojuny.browser.selected"; visibleWhen.equals = "firefox";
        programs.firefox.profiles.default.name = "default";

        # @option widget = "switch"; label = "Default profile"; group = "Firefox"; order = 11; visibleWhen.path = "ojuny.browser.selected"; visibleWhen.equals = "firefox";
        programs.firefox.profiles.default.isDefault = true;

        # @option widget = "text"; label = "Search engine"; group = "Firefox"; order = 12; description = "Engine the profile starts with."; visibleWhen.path = "ojuny.browser.selected"; visibleWhen.equals = "firefox";
        programs.firefox.profiles.default.search.default = "google";

        programs.firefox.profiles.default.settings =
          lib.mkIf (osConfig.ojuny.browser.firefox.autoEnableExtensions or false)
            {
              "extensions.autoDisableScopes" = 0;
            };

        programs.firefox.profiles.default.search.engines = firefoxEngines;

        programs.firefox.profiles.default.bookmarks = lib.mkIf (firefoxBookmarks != [ ]) {
          force = true;
          settings = firefoxBookmarks;
        };

        programs.firefox.profiles.default.extensions.packages =
          osConfig.ojuny.browser.firefox.extensions or [ ];

        # @option widget = "list"; label = "Stylix profile names"; group = "Firefox"; groupOrder = 20; order = 9; itemLabel = "Profile key"; addLabel = "Add profile"; visibleWhen.path = "ojuny.browser.selected"; visibleWhen.equals = "firefox"; description = "Firefox profile keys themed by Stylix. The template profile key is default.";
        stylix.targets.firefox.profileNames = [ "default" ];

        stylix.targets.firefox.colorTheme.enable = osConfig.ojuny.browser.firefox.stylixColorTheme or true;

        programs.firefox.profiles.default.extensions.force = true;

      };
    };

}
