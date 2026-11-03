/*
  @menu
  displayname = "Dot and floating island";
  icon = "radio_button_checked-symbolic";
  order = 15;
  description = "Independent dot and floating island surfaces, separate from the selected bar";
  category = "04-GUI";
*/

{ self, inputs, ... }: {

  flake.modules.nixos.desktop-dot =
    { config, lib, ... }:

    let
      routeMap = {
        routeLauncher = "islandRouteLauncher";
        routeControlCenter = "islandRouteControlCenter";
        routeNotificationCenter = "islandRouteNotificationCenter";
        routeClipboard = "islandRouteClipboard";
        routePowerMenu = "islandRoutePowerMenu";
        routeDashboard = "islandRouteDash";
        routeMedia = "islandRouteMedia";
        routeWeather = "islandRouteWeather";
        routeWallpaper = "islandRouteWallpaper";
      };

      routesFor =
        settings:
        lib.mapAttrs' (
          option: route:
          lib.nameValuePair route (if settings.${option} then "island" else "follow")
        ) routeMap;
    in
    {
      options.ojuny.dux.dot = lib.mkOption {
        type = lib.types.toml;
        default = { };
        description = "Standalone dot bar config. Dux Shell finds it through the dot flag and it never changes the selected bar.";
      };

      options.ojuny.dux.floatingIsland = lib.mkOption {
        type = lib.types.toml;
        default = { };
        description = "Standalone free-floating island bar config. Separate from the island inside the selected bar.";
      };

      config = {

        # Dot
        # @option widget = "switch"; label = "Show the dot"; group = "Dot"; groupOrder = 10; order = 10; description = "Enable the free-floating dot. The selected bar is not changed.";
        ojuny.dux.dot.enabled = false;

        # @option widget = "text"; label = "Name"; group = "Dot"; groupOrder = 10; order = 20; description = "Display name for the dot bar config.";
        ojuny.dux.dot.name = "Dot";

        # @option widget = "slider"; label = "Size"; group = "Dot"; groupOrder = 10; order = 30; min = 24; max = 160; step = 1; unit = "px"; description = "Diameter of the dot.";
        ojuny.dux.dot.islandFreeSize = 48;

        # @option widget = "dropdown"; label = "Icon"; group = "Dot"; groupOrder = 10; order = 40; choices = [ "icon" "os" "dank" "compositor" "custom" ]; description = "Artwork shown inside the dot.";
        ojuny.dux.dot.islandFreeIconMode = "icon";

        # @option widget = "text"; label = "Symbol"; group = "Dot"; groupOrder = 10; order = 50; visibleWhen.path = "ojuny.dux.dot.islandFreeIconMode"; visibleWhen.equals = "icon"; description = "Icon name used when the icon mode is symbol.";
        ojuny.dux.dot.islandFreeIcon = "blur_on";

        # @option widget = "text"; label = "Custom image"; group = "Dot"; groupOrder = 10; order = 60; visibleWhen.path = "ojuny.dux.dot.islandFreeIconMode"; visibleWhen.equals = "custom"; description = "Image path used when the icon mode is custom.";
        ojuny.dux.dot.islandFreeIconPath = "";

        # @option widget = "text"; label = "Icon color"; group = "Dot"; groupOrder = 10; order = 70; description = "Theme role name or hex value for the dot icon.";
        ojuny.dux.dot.islandFreeIconColor = "primary";

        # @option widget = "spin"; label = "Edge margin"; group = "Dot"; groupOrder = 10; order = 80; min = 0; max = 64; unit = "px"; description = "Gap kept between the dot and the display edge.";
        ojuny.dux.dot.islandFreeEdgeMargin = 2;

        # @option widget = "spin"; label = "Idle delay"; group = "Dot"; groupOrder = 10; order = 90; min = 0; max = 30000; unit = "ms"; description = "Time before the dot fades while idle. 0 disables fading.";
        ojuny.dux.dot.islandFreeIdleDelay = 2500;

        # @option widget = "slider"; label = "Idle size"; group = "Dot"; groupOrder = 10; order = 100; min = 0.2; max = 1.0; step = 0.01; description = "How far the dot shrinks while idle.";
        ojuny.dux.dot.islandFreeIdleScale = 0.4;

        # @option widget = "slider"; label = "Idle opacity"; group = "Dot"; groupOrder = 10; order = 110; min = 0.0; max = 1.0; step = 0.05; description = "Opacity of the dot while idle.";
        ojuny.dux.dot.islandFreeIdleOpacity = 0.45;

        # @option widget = "slider"; label = "Opacity"; group = "Dot surface"; groupOrder = 20; order = 10; min = 0.0; max = 1.0; step = 0.05; description = "Opacity of the dot background.";
        ojuny.dux.dot.transparency = 1.0;

        # @option widget = "dropdown"; label = "Background"; group = "Dot surface"; groupOrder = 20; order = 20; choices = [ "default" "surfaceText" "primary" "primaryContainer" "secondary" "secondaryContainer" "tertiary" "tertiaryContainer" "s" "sc" "sch" "schh" "custom" ]; description = "Theme role used for the dot background.";
        ojuny.dux.dot.surfaceColor = "sch";

        # @option widget = "color"; label = "Custom background"; group = "Dot surface"; groupOrder = 20; order = 30; visibleWhen.path = "ojuny.dux.dot.surfaceColor"; visibleWhen.equals = "custom"; description = "Background color used when the dot background is custom.";
        ojuny.dux.dot.surfaceCustomColor = "#6750a4";

        # @option widget = "dropdown"; label = "Palette"; group = "Dot surface"; groupOrder = 20; order = 40; choices = [ "default" "bright" "dim" ]; description = "Surface tone used by the dot.";
        ojuny.dux.dot.islandPalette = "default";

        # @option widget = "switch"; label = "High contrast"; group = "Dot surface"; groupOrder = 20; order = 50; description = "Draw the dot with a higher contrast outline.";
        ojuny.dux.dot.islandHighContrast = false;

        # @option widget = "list"; label = "Screens"; group = "Dot displays"; groupOrder = 30; order = 10; itemLabel = "Screen"; addLabel = "Add screen"; description = "Screen names, or all. A dot normally follows every screen.";
        ojuny.dux.dot.screenPreferences = [ "all" ];

        # @option widget = "switch"; label = "Show on last display"; group = "Dot displays"; groupOrder = 30; order = 20; description = "Keep the dot on the display it was last shown on.";
        ojuny.dux.dot.showOnLastDisplay = true;

        # @option widget = "dropdown"; label = "Shared shortcuts"; group = "Dot behaviour"; groupOrder = 15; order = 10; choices = [ "normal" "always" "last-used" ]; description = "Normal sends launcher, dashboard, control center and notification shortcuts where they normally go. Always sends them to the dot even when a bar provides them. Last used sends them to the island last used on the display. Always here overrides the per-menu switches.";
        ojuny.dux.dot.islandSharedRouting = "normal";

        # @option widget = "switch"; label = "Always open launcher here"; group = "Dot behaviour"; groupOrder = 15; order = 20; description = "Route launcher shortcuts to the dot even when a bar provides a launcher. Off follows the shared shortcuts rule.";
        ojuny.dux.dot.routeLauncher = false;

        # @option widget = "switch"; label = "Always open control center here"; group = "Dot behaviour"; groupOrder = 15; order = 30; description = "Route control center shortcuts to the dot even when a bar provides a control center. Off follows the shared shortcuts rule.";
        ojuny.dux.dot.routeControlCenter = false;

        # @option widget = "switch"; label = "Always open notification center here"; group = "Dot behaviour"; groupOrder = 15; order = 40; description = "Route notification center shortcuts to the dot even when a bar provides a notification center. Off follows the shared shortcuts rule.";
        ojuny.dux.dot.routeNotificationCenter = false;

        # @option widget = "switch"; label = "Always open clipboard here"; group = "Dot behaviour"; groupOrder = 15; order = 50; description = "Route clipboard shortcuts to the dot even when a bar provides a clipboard. Off follows the shared shortcuts rule.";
        ojuny.dux.dot.routeClipboard = false;

        # @option widget = "switch"; label = "Always open power menu here"; group = "Dot behaviour"; groupOrder = 15; order = 60; description = "Route power menu shortcuts to the dot even when a bar provides a power menu. Off follows the shared shortcuts rule.";
        ojuny.dux.dot.routePowerMenu = false;

        # @option widget = "switch"; label = "Always open dashboard here"; group = "Dot behaviour"; groupOrder = 15; order = 70; description = "Route dashboard shortcuts to the dot even when a bar provides a dashboard. Off follows the shared shortcuts rule.";
        ojuny.dux.dot.routeDashboard = true;

        # @option widget = "switch"; label = "Always open media here"; group = "Dot behaviour"; groupOrder = 15; order = 80; description = "Route media shortcuts to the dot even when a bar provides media. Off follows the shared shortcuts rule.";
        ojuny.dux.dot.routeMedia = true;

        # @option widget = "switch"; label = "Always open weather here"; group = "Dot behaviour"; groupOrder = 15; order = 90; description = "Route weather shortcuts to the dot even when a bar provides weather. Off follows the shared shortcuts rule.";
        ojuny.dux.dot.routeWeather = true;

        # @option widget = "switch"; label = "Always open wallpapers here"; group = "Dot behaviour"; groupOrder = 15; order = 100; description = "Route wallpaper shortcuts to the dot even when a bar provides wallpapers. Off follows the shared shortcuts rule.";
        ojuny.dux.dot.routeWallpaper = true;

        # @option widget = "switch"; label = "Use standard notification popups"; group = "Dot notifications"; groupOrder = 17; order = 10; description = "Show arriving notifications as regular popups. Off shows them inside the dot.";
        ojuny.dux.dot.islandNotificationPopups = false;

        # @option widget = "switch"; label = "Show OSDs in the dot"; group = "Dot notifications"; groupOrder = 17; order = 20; description = "Show volume and brightness changes inside the dot. Off uses the standard on-screen displays.";
        ojuny.dux.dot.islandSystemOsd = true;

        # @option widget = "switch"; label = "Pulse when the charger connects"; group = "Dot notifications"; groupOrder = 17; order = 30; description = "Show the battery briefly when power is connected or removed.";
        ojuny.dux.dot.islandChargingPulse = true;

        # @option widget = "switch"; label = "Expand notifications by default"; group = "Dot notifications"; groupOrder = 17; order = 40; description = "Open arriving notifications expanded.";
        ojuny.dux.dot.islandNotificationExpand = false;

        # @option widget = "switch"; label = "Clear badge when opened"; group = "Dot notifications"; groupOrder = 17; order = 50; description = "Clear the notification badge when the notification center opens.";
        ojuny.dux.dot.islandNotificationBadgeClearOnOpen = false;

        # @option widget = "switch"; label = "Fixed dot flag"; group = "Dot"; groupOrder = 10; hidden = true;
        ojuny.dux.dot.dot = true;

        # @option widget = "switch"; label = "Fixed island flag"; group = "Dot"; groupOrder = 10; hidden = true;
        ojuny.dux.dot.island = false;

        # @option widget = "switch"; label = "Fixed visibility"; group = "Dot"; groupOrder = 10; hidden = true;
        ojuny.dux.dot.visible = true;

        # @option widget = "switch"; label = "Fixed auto hide"; group = "Dot"; groupOrder = 10; hidden = true;
        ojuny.dux.dot.autoHide = false;

        # @option widget = "switch"; label = "Follow interface style"; group = "Dot"; groupOrder = 10; hidden = true;
        ojuny.dux.dot.followInterfaceStyle = false;

        # @option widget = "spin"; label = "Order"; group = "Dot"; groupOrder = 10; hidden = true;
        ojuny.dux.dot._order = 20;

        # Floating island
        # @option widget = "switch"; label = "Show the floating island"; group = "Floating island"; groupOrder = 40; order = 10; description = "Enable a free-floating island that runs alongside the selected bar.";
        ojuny.dux.floatingIsland.enabled = false;

        # @option widget = "text"; label = "Name"; group = "Floating island"; groupOrder = 40; order = 20; description = "Display name for the floating island bar config.";
        ojuny.dux.floatingIsland.name = "Floating island";

        # @option widget = "dropdown"; label = "Orientation"; group = "Floating island"; groupOrder = 40; order = 30; choices = [ "0" "2" ]; description = "0 is a horizontal row, 2 is a vertical row. Free islands use the bar position for orientation.";
        ojuny.dux.floatingIsland.position = 0;

        # @option widget = "spin"; label = "Edge margin"; group = "Floating island"; groupOrder = 40; order = 40; min = 0; max = 64; unit = "px"; description = "Gap kept between the floating island and the display edge.";
        ojuny.dux.floatingIsland.islandFreeEdgeMargin = 2;

        # @option widget = "slider"; label = "Opacity"; group = "Floating island surface"; groupOrder = 50; order = 10; min = 0.0; max = 1.0; step = 0.05; description = "Opacity of the floating island background.";
        ojuny.dux.floatingIsland.transparency = 1.0;

        # @option widget = "dropdown"; label = "Background"; group = "Floating island surface"; groupOrder = 50; order = 20; choices = [ "default" "surfaceText" "primary" "primaryContainer" "secondary" "secondaryContainer" "tertiary" "tertiaryContainer" "s" "sc" "sch" "schh" "custom" ]; description = "Theme role used for the floating island background.";
        ojuny.dux.floatingIsland.surfaceColor = "sch";

        # @option widget = "color"; label = "Custom background"; group = "Floating island surface"; groupOrder = 50; order = 30; visibleWhen.path = "ojuny.dux.floatingIsland.surfaceColor"; visibleWhen.equals = "custom"; description = "Background color used when the floating island background is custom.";
        ojuny.dux.floatingIsland.surfaceCustomColor = "#6750a4";

        # @option widget = "dropdown"; label = "Palette"; group = "Floating island surface"; groupOrder = 50; order = 40; choices = [ "default" "bright" "dim" ]; description = "Surface tone used by the floating island.";
        ojuny.dux.floatingIsland.islandPalette = "default";

        # @option widget = "switch"; label = "High contrast"; group = "Floating island surface"; groupOrder = 50; order = 50; description = "Draw the floating island with a higher contrast outline.";
        ojuny.dux.floatingIsland.islandHighContrast = false;

        # @option widget = "list"; label = "Screens"; group = "Floating island displays"; groupOrder = 60; order = 10; itemLabel = "Screen"; addLabel = "Add screen"; description = "Screen names, or all.";
        ojuny.dux.floatingIsland.screenPreferences = [ "all" ];

        # @option widget = "switch"; label = "Show on last display"; group = "Floating island displays"; groupOrder = 60; order = 20; description = "Keep the floating island on the display it was last shown on.";
        ojuny.dux.floatingIsland.showOnLastDisplay = true;

        # @option widget = "dropdown"; label = "Shared shortcuts"; group = "Floating island behaviour"; groupOrder = 45; order = 10; choices = [ "normal" "always" "last-used" ]; description = "Normal sends launcher, dashboard, control center and notification shortcuts where they normally go. Always sends them to the floating island even when a bar provides them. Last used sends them to the island last used on the display. Always here overrides the per-menu switches.";
        ojuny.dux.floatingIsland.islandSharedRouting = "normal";

        # @option widget = "switch"; label = "Always open launcher here"; group = "Floating island behaviour"; groupOrder = 45; order = 20; description = "Route launcher shortcuts to the floating island even when a bar provides a launcher. Off follows the shared shortcuts rule.";
        ojuny.dux.floatingIsland.routeLauncher = false;

        # @option widget = "switch"; label = "Always open control center here"; group = "Floating island behaviour"; groupOrder = 45; order = 30; description = "Route control center shortcuts to the floating island even when a bar provides a control center. Off follows the shared shortcuts rule.";
        ojuny.dux.floatingIsland.routeControlCenter = false;

        # @option widget = "switch"; label = "Always open notification center here"; group = "Floating island behaviour"; groupOrder = 45; order = 40; description = "Route notification center shortcuts to the floating island even when a bar provides a notification center. Off follows the shared shortcuts rule.";
        ojuny.dux.floatingIsland.routeNotificationCenter = false;

        # @option widget = "switch"; label = "Always open clipboard here"; group = "Floating island behaviour"; groupOrder = 45; order = 50; description = "Route clipboard shortcuts to the floating island even when a bar provides a clipboard. Off follows the shared shortcuts rule.";
        ojuny.dux.floatingIsland.routeClipboard = false;

        # @option widget = "switch"; label = "Always open power menu here"; group = "Floating island behaviour"; groupOrder = 45; order = 60; description = "Route power menu shortcuts to the floating island even when a bar provides a power menu. Off follows the shared shortcuts rule.";
        ojuny.dux.floatingIsland.routePowerMenu = false;

        # @option widget = "switch"; label = "Always open dashboard here"; group = "Floating island behaviour"; groupOrder = 45; order = 70; description = "Route dashboard shortcuts to the floating island even when a bar provides a dashboard. Off follows the shared shortcuts rule.";
        ojuny.dux.floatingIsland.routeDashboard = true;

        # @option widget = "switch"; label = "Always open media here"; group = "Floating island behaviour"; groupOrder = 45; order = 80; description = "Route media shortcuts to the floating island even when a bar provides media. Off follows the shared shortcuts rule.";
        ojuny.dux.floatingIsland.routeMedia = true;

        # @option widget = "switch"; label = "Always open weather here"; group = "Floating island behaviour"; groupOrder = 45; order = 90; description = "Route weather shortcuts to the floating island even when a bar provides weather. Off follows the shared shortcuts rule.";
        ojuny.dux.floatingIsland.routeWeather = true;

        # @option widget = "switch"; label = "Always open wallpapers here"; group = "Floating island behaviour"; groupOrder = 45; order = 100; description = "Route wallpaper shortcuts to the floating island even when a bar provides wallpapers. Off follows the shared shortcuts rule.";
        ojuny.dux.floatingIsland.routeWallpaper = true;

        # @option widget = "switch"; label = "Use standard notification popups"; group = "Floating island notifications"; groupOrder = 47; order = 10; description = "Show arriving notifications as regular popups. Off shows them inside the floating island.";
        ojuny.dux.floatingIsland.islandNotificationPopups = false;

        # @option widget = "switch"; label = "Show OSDs in the floating island"; group = "Floating island notifications"; groupOrder = 47; order = 20; description = "Show volume and brightness changes inside the floating island. Off uses the standard on-screen displays.";
        ojuny.dux.floatingIsland.islandSystemOsd = true;

        # @option widget = "switch"; label = "Pulse when the charger connects"; group = "Floating island notifications"; groupOrder = 47; order = 30; description = "Show the battery briefly when power is connected or removed.";
        ojuny.dux.floatingIsland.islandChargingPulse = true;

        # @option widget = "switch"; label = "Expand notifications by default"; group = "Floating island notifications"; groupOrder = 47; order = 40; description = "Open arriving notifications expanded.";
        ojuny.dux.floatingIsland.islandNotificationExpand = false;

        # @option widget = "switch"; label = "Clear badge when opened"; group = "Floating island notifications"; groupOrder = 47; order = 50; description = "Clear the notification badge when the notification center opens.";
        ojuny.dux.floatingIsland.islandNotificationBadgeClearOnOpen = false;

        # @option widget = "switch"; label = "Fixed dot flag"; group = "Floating island"; groupOrder = 40; hidden = true;
        ojuny.dux.floatingIsland.dot = false;

        # @option widget = "switch"; label = "Fixed island flag"; group = "Floating island"; groupOrder = 40; hidden = true;
        ojuny.dux.floatingIsland.island = true;

        # @option widget = "switch"; label = "Fixed floating flag"; group = "Floating island"; groupOrder = 40; hidden = true;
        ojuny.dux.floatingIsland.islandFloating = true;

        # @option widget = "text"; label = "Fixed placement"; group = "Floating island"; groupOrder = 40; hidden = true;
        ojuny.dux.floatingIsland.islandPlacement = "free";

        # @option widget = "switch"; label = "Fixed visibility"; group = "Floating island"; groupOrder = 40; hidden = true;
        ojuny.dux.floatingIsland.visible = true;

        # @option widget = "switch"; label = "Fixed auto hide"; group = "Floating island"; groupOrder = 40; hidden = true;
        ojuny.dux.floatingIsland.autoHide = false;

        # @option widget = "switch"; label = "Follow interface style"; group = "Floating island"; groupOrder = 40; hidden = true;
        ojuny.dux.floatingIsland.followInterfaceStyle = false;

        # @option widget = "spin"; label = "Order"; group = "Floating island"; groupOrder = 40; hidden = true;
        ojuny.dux.floatingIsland._order = 30;

        desktop.ojuny.dux.barConfigs.dot =
          removeAttrs config.ojuny.dux.dot (builtins.attrNames routeMap)
          // routesFor config.ojuny.dux.dot
          // {
            dot = true;
            island = false;
            visible = true;
            autoHide = false;
          };

        desktop.ojuny.dux.barConfigs.floatingIsland =
          removeAttrs config.ojuny.dux.floatingIsland (builtins.attrNames routeMap)
          // routesFor config.ojuny.dux.floatingIsland
          // {
            dot = false;
            island = true;
            islandFloating = true;
            islandPlacement = "free";
            visible = true;
            autoHide = false;
          };
      };
    };
}
