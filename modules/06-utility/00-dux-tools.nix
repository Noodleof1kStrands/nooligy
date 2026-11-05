/*
  @menu
  displayname = "Dux tools";
  icon = "applications-utilities-symbolic";
  order = 10;
  description = "Search, files, calendar and system resource settings";
  category = "06-Utility";
*/

{ self, inputs, ... }: {

  flake.modules.nixos.desktop-dux-tools =
    { config, lib, ... }:
    {
      options.ojuny.tools.dsearch = {
        enable = lib.mkEnableOption "the dsearch indexer";
        indexPaths = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ "~" ];
          description = "Paths indexed by dsearch.";
        };
        maxDepth = lib.mkOption {
          type = lib.types.int;
          default = 6;
          description = "Maximum directory depth per index path. 0 means unlimited.";
        };
        excludeHidden = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Skip hidden files and directories.";
        };
        extractExif = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Extract EXIF metadata from images.";
        };
        workerCount = lib.mkOption {
          type = lib.types.int;
          default = 4;
          description = "Number of indexing workers.";
        };
        httpEnabled = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Enable the unauthenticated HTTP API.";
        };
        maxFileBytes = lib.mkOption {
          type = lib.types.int;
          default = 2097152;
          description = "Largest file dsearch indexes, in bytes.";
        };
      };

      options.ojuny.tools.duxFiles = {
        themeMode = lib.mkOption {
          type = lib.types.enum [ "auto" "dark" "light" ];
          default = "auto";
          description = "Dux Files theme mode.";
        };
        defaultView = lib.mkOption {
          type = lib.types.enum [ "list" "grid" ];
          default = "list";
          description = "Default file view.";
        };
        showTitleBar = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Show the Dux Files top bar. The app default is on.";
        };
        density = lib.mkOption {
          type = lib.types.enum [ "spacious" "comfortable" "compact" "dense" ];
          default = "comfortable";
          description = "Interface density.";
        };
        defaultSort = lib.mkOption {
          type = lib.types.enum [ "name" "size" "mtime" "type" ];
          default = "name";
          description = "Default sort key.";
        };
        defaultSortDescending = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Sort in descending order by default.";
        };
        showHidden = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Show hidden files.";
        };
        showExtensions = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Show file extensions in the name column.";
        };
        foldersFirst = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Sort folders before files.";
        };
        rememberFolderViews = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Remember the view and sort per folder.";
        };
        folderCounts = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Show item counts on folders.";
        };
        confirmTrash = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Ask before moving files to the trash.";
        };
        clickToOpen = lib.mkOption {
          type = lib.types.enum [ "single" "double" ];
          default = "double";
          description = "Open files with a single or double click.";
        };
        thumbnails = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Show image and video thumbnails.";
        };
        thumbnailSizeLimitMb = lib.mkOption {
          type = lib.types.int;
          default = 64;
          description = "Largest file that gets a thumbnail, in megabytes.";
        };
        terminal = lib.mkOption {
          type = lib.types.str;
          default = "";
          description = "Terminal Dux Files opens. An empty value auto-detects one.";
        };
        registerFileManager = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Register Dux Files as the session file manager.";
        };
        recentFiles = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Show recent files.";
        };
        sidebarCollapsed = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Collapse the sidebar by default.";
        };
        showDevicesSidebar = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Show the devices section in the sidebar.";
        };
        showNetworkSidebar = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Show the network section in the sidebar.";
        };
        showGamesSidebar = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Show the games section in the sidebar.";
        };
        closeBehavior = lib.mkOption {
          type = lib.types.enum [ "hide" "quit" ];
          default = "quit";
          description = "What closing the window does.";
        };
        opener = lib.mkOption {
          type = lib.types.str;
          default = "";
          description = "Program used to open files. Empty uses the default application.";
        };
        vimKeys = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Enable Vim-style navigation keys.";
        };
        searchExcludes = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ ];
          description = "Names or paths excluded from search.";
        };
      };

      options.ojuny.tools.calendar = {
        enable = lib.mkEnableOption "Dux Calendar";
        timeFormat = lib.mkOption {
          type = lib.types.enum [ "auto" "12h" "24h" ];
          default = "auto";
          description = "Clock format.";
        };
        firstDayOfWeek = lib.mkOption {
          type = lib.types.int;
          default = -1;
          description = "First day of the week, 0 Sunday to 6 Saturday. -1 follows the locale.";
        };
        showTasks = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Show the tasks view.";
        };
        remindersEnabled = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Enable event reminders.";
        };
        defaultReminderMinutes = lib.mkOption {
          type = lib.types.int;
          default = 10;
          description = "Default reminder lead time in minutes.";
        };
        snoozeMinutes = lib.mkOption {
          type = lib.types.int;
          default = 5;
          description = "Default snooze time in minutes.";
        };
        notificationSounds = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Play a sound with reminders.";
        };
        showWeekNumbers = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Show week numbers.";
        };
        defaultEventDurationMinutes = lib.mkOption {
          type = lib.types.int;
          default = 30;
          description = "Default new event length in minutes.";
        };
        reminderPersist = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Keep reminders until they are dismissed.";
        };
        allDayReminders = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Send reminders for all-day events.";
        };
        allDayReminderTime = lib.mkOption {
          type = lib.types.str;
          default = "09:00";
          description = "Local time an all-day reminder fires, as HH:mm.";
        };
        closeBehavior = lib.mkOption {
          type = lib.types.enum [ "minimize" "quit" ];
          default = "minimize";
          description = "What closing the window does.";
        };
      };

      options.ojuny.tools.gop = {
        enable = lib.mkEnableOption "the standalone dgop HTTP API";
        apiPort = lib.mkOption {
          type = lib.types.port;
          default = 63484;
          description = "Port for the dgop HTTP API.";
        };
      };

      config = {
        # @option widget = "switch"; label = "Enable dsearch"; group = "Search"; groupOrder = 10; order = 10; description = "Run the dsearch indexer as a user service.";
        ojuny.tools.dsearch.enable = true;

        # @option widget = "list"; label = "Index paths"; group = "Search"; groupOrder = 10; order = 20; itemLabel = "Path"; addLabel = "Add path"; description = "Paths indexed by dsearch.";
        ojuny.tools.dsearch.indexPaths = [ "~" ];

        # @option widget = "spin"; label = "Max depth"; group = "Search"; groupOrder = 10; order = 30; min = 0; max = 64; description = "Maximum directory depth per index path. 0 means unlimited.";
        ojuny.tools.dsearch.maxDepth = 6;

        # @option widget = "switch"; label = "Exclude hidden"; group = "Search"; groupOrder = 10; order = 40;
        ojuny.tools.dsearch.excludeHidden = true;

        # @option widget = "switch"; label = "Extract EXIF"; group = "Search"; groupOrder = 10; order = 50;
        ojuny.tools.dsearch.extractExif = true;

        # @option widget = "spin"; label = "Workers"; group = "Search"; groupOrder = 10; order = 60; min = 1; max = 32;
        ojuny.tools.dsearch.workerCount = 4;

        # @option widget = "switch"; label = "HTTP API"; group = "Search"; groupOrder = 10; order = 70; description = "The HTTP API has no authentication. Leave off unless another client needs it.";
        ojuny.tools.dsearch.httpEnabled = false;

        # @option widget = "spin"; label = "Max file size"; group = "Search"; groupOrder = 10; order = 80; min = 1024; max = 1073741824; step = 1024; unit = "B"; 
        ojuny.tools.dsearch.maxFileBytes = 2097152;

        # @option widget = "dropdown"; label = "Theme"; group = "Files"; groupOrder = 20; order = 10; choices = [ "auto" "dark" "light" ];
        ojuny.tools.duxFiles.themeMode = "auto";

        # @option widget = "switch"; label = "Show title bar"; group = "Files"; groupOrder = 20; order = 15; description = "The Dux Files top bar is off by default. The app default is on.";
        ojuny.tools.duxFiles.showTitleBar = false;

        # @option widget = "dropdown"; label = "Default view"; group = "Files"; groupOrder = 20; order = 20; choices = [ "list" "grid" ];
        ojuny.tools.duxFiles.defaultView = "list";

        # @option widget = "switch"; label = "Show hidden files"; group = "Files"; groupOrder = 20; order = 30;
        ojuny.tools.duxFiles.showHidden = false;

        # @option widget = "switch"; label = "Folders first"; group = "Files"; groupOrder = 20; order = 40;
        ojuny.tools.duxFiles.foldersFirst = true;

        # @option widget = "switch"; label = "Confirm trash"; group = "Files"; groupOrder = 20; order = 50;
        ojuny.tools.duxFiles.confirmTrash = false;

        # @option widget = "text"; label = "Terminal"; group = "Files"; groupOrder = 20; order = 60; description = "Leave empty to auto-detect a terminal.";
        ojuny.tools.duxFiles.terminal = "";

        # @option widget = "switch"; label = "Register file manager"; group = "Files"; groupOrder = 20; order = 70;
        ojuny.tools.duxFiles.registerFileManager = true;

        # @option widget = "switch"; label = "Recent files"; group = "Files"; groupOrder = 20; order = 80;
        ojuny.tools.duxFiles.recentFiles = true;

        # @option widget = "list"; label = "Search excludes"; group = "Files"; groupOrder = 20; order = 90; advanced = true; itemLabel = "Name or path"; addLabel = "Add exclude";
        ojuny.tools.duxFiles.searchExcludes = [ ];

        # @option widget = "dropdown"; label = "Sort by"; group = "Files"; groupOrder = 20; order = 100; choices = [ "name" "size" "mtime" "type" ];
        ojuny.tools.duxFiles.defaultSort = "name";

        # @option widget = "switch"; label = "Sort descending"; group = "Files"; groupOrder = 20; order = 110;
        ojuny.tools.duxFiles.defaultSortDescending = false;

        # @option widget = "dropdown"; label = "Density"; group = "Files"; groupOrder = 20; order = 120; choices = [ "spacious" "comfortable" "compact" "dense" ];
        ojuny.tools.duxFiles.density = "comfortable";

        # @option widget = "switch"; label = "Show extensions"; group = "Files"; groupOrder = 20; order = 130;
        ojuny.tools.duxFiles.showExtensions = true;

        # @option widget = "switch"; label = "Remember folder views"; group = "Files"; groupOrder = 20; order = 140;
        ojuny.tools.duxFiles.rememberFolderViews = true;

        # @option widget = "switch"; label = "Folder counts"; group = "Files"; groupOrder = 20; order = 150;
        ojuny.tools.duxFiles.folderCounts = true;

        # @option widget = "dropdown"; label = "Click to open"; group = "Files"; groupOrder = 20; order = 160; choices = [ "single" "double" ];
        ojuny.tools.duxFiles.clickToOpen = "double";

        # @option widget = "switch"; label = "Thumbnails"; group = "Files"; groupOrder = 20; order = 170;
        ojuny.tools.duxFiles.thumbnails = true;

        # @option widget = "spin"; label = "Thumbnail size limit"; group = "Files"; groupOrder = 20; order = 180; min = 1; max = 10240; unit = "MB"; visibleWhen.path = "ojuny.tools.duxFiles.thumbnails"; visibleWhen.equals = true;
        ojuny.tools.duxFiles.thumbnailSizeLimitMb = 64;

        # @option widget = "switch"; label = "Collapse sidebar"; group = "Files"; groupOrder = 20; order = 190;
        ojuny.tools.duxFiles.sidebarCollapsed = false;

        # @option widget = "switch"; label = "Devices sidebar"; group = "Files"; groupOrder = 20; order = 200;
        ojuny.tools.duxFiles.showDevicesSidebar = true;

        # @option widget = "switch"; label = "Network sidebar"; group = "Files"; groupOrder = 20; order = 210;
        ojuny.tools.duxFiles.showNetworkSidebar = true;

        # @option widget = "switch"; label = "Games sidebar"; group = "Files"; groupOrder = 20; order = 220;
        ojuny.tools.duxFiles.showGamesSidebar = true;

        # @option widget = "dropdown"; label = "Close behavior"; group = "Files"; groupOrder = 20; order = 230; choices = [ "hide" "quit" ];
        ojuny.tools.duxFiles.closeBehavior = "quit";

        # @option widget = "text"; label = "Opener"; group = "Files"; groupOrder = 20; order = 240; description = "Leave empty to use the default application.";
        ojuny.tools.duxFiles.opener = "";

        # @option widget = "switch"; label = "Vim keys"; group = "Files"; groupOrder = 20; order = 250;
        ojuny.tools.duxFiles.vimKeys = false;

        # @option widget = "switch"; label = "Enable Dux Calendar"; group = "Calendar"; groupOrder = 30; order = 10; description = "Run the calendar daemon and install its session service.";
        ojuny.tools.calendar.enable = true;

        # @option widget = "dropdown"; label = "Time format"; group = "Calendar"; groupOrder = 30; order = 20; choices = [ "auto" "12h" "24h" ];
        ojuny.tools.calendar.timeFormat = "auto";

        # @option widget = "dropdown"; label = "First day of week"; group = "Calendar"; groupOrder = 30; order = 30; choices = [ "-1" "0" "1" "2" "3" "4" "5" "6" ]; description = "-1 follows the locale, 0 Sunday to 6 Saturday.";
        ojuny.tools.calendar.firstDayOfWeek = -1;

        # @option widget = "switch"; label = "Show tasks"; group = "Calendar"; groupOrder = 30; order = 40;
        ojuny.tools.calendar.showTasks = true;

        # @option widget = "switch"; label = "Reminders"; group = "Calendar"; groupOrder = 30; order = 50;
        ojuny.tools.calendar.remindersEnabled = true;

        # @option widget = "spin"; label = "Default reminder"; group = "Calendar"; groupOrder = 30; order = 60; min = 0; max = 1440; unit = "min";
        ojuny.tools.calendar.defaultReminderMinutes = 10;

        # @option widget = "spin"; label = "Snooze"; group = "Calendar"; groupOrder = 30; order = 70; min = 1; max = 1440; unit = "min";
        ojuny.tools.calendar.snoozeMinutes = 5;

        # @option widget = "switch"; label = "Notification sounds"; group = "Calendar"; groupOrder = 30; order = 80;
        ojuny.tools.calendar.notificationSounds = false;

        # @option widget = "switch"; label = "Week numbers"; group = "Calendar"; groupOrder = 30; order = 90;
        ojuny.tools.calendar.showWeekNumbers = false;

        # @option widget = "spin"; label = "Default event duration"; group = "Calendar"; groupOrder = 30; order = 100; min = 5; max = 1440; unit = "min";
        ojuny.tools.calendar.defaultEventDurationMinutes = 30;

        # @option widget = "switch"; label = "Persistent reminders"; group = "Calendar"; groupOrder = 30; order = 110;
        ojuny.tools.calendar.reminderPersist = true;

        # @option widget = "switch"; label = "All-day reminders"; group = "Calendar"; groupOrder = 30; order = 120;
        ojuny.tools.calendar.allDayReminders = false;

        # @option widget = "text"; label = "All-day reminder time"; group = "Calendar"; groupOrder = 30; order = 130; visibleWhen.path = "ojuny.tools.calendar.allDayReminders"; visibleWhen.equals = true; description = "Local time as HH:mm.";
        ojuny.tools.calendar.allDayReminderTime = "09:00";

        # @option widget = "dropdown"; label = "Close behavior"; group = "Calendar"; groupOrder = 30; order = 140; choices = [ "minimize" "quit" ];
        ojuny.tools.calendar.closeBehavior = "minimize";

        # @option widget = "switch"; label = "dgop HTTP API"; group = "System resources"; groupOrder = 40; order = 10; description = "Dux Modular Shell uses the embedded dgop library. Enable this only for clients that call the HTTP API.";
        ojuny.tools.gop.enable = false;

        # @option widget = "spin"; label = "API port"; group = "System resources"; groupOrder = 40; order = 20; min = 1024; max = 65535; visibleWhen.path = "ojuny.tools.gop.enable"; visibleWhen.equals = true;
        ojuny.tools.gop.apiPort = 63484;
      };
    };

  flake.modules.homeManager.dux-tools =
    {
      config,
      lib,
      pkgs,
      osConfig ? { },
      ...
    }:
    let
      tools = osConfig.ojuny.tools or { };
      dsearch = tools.dsearch or { };
      duxFiles = tools.duxFiles or { };
      calendar = tools.calendar or { };
      gop = tools.gop or { };
      dgop = inputs.ojuny-desktop.inputs.dux-gop.packages.${pkgs.stdenv.hostPlatform.system}.default;

      calendarPolicy = {
        timeFormat = calendar.timeFormat or "auto";
        firstDayOfWeek = calendar.firstDayOfWeek or (-1);
        remindersEnabled = calendar.remindersEnabled or true;
        defaultReminderMinutes = calendar.defaultReminderMinutes or 10;
        snoozeMinutes = calendar.snoozeMinutes or 5;
        notificationSounds = calendar.notificationSounds or false;
        showWeekNumbers = calendar.showWeekNumbers or false;
        showTasks = calendar.showTasks or true;
        defaultEventDurationMinutes = calendar.defaultEventDurationMinutes or 30;
        reminderPersist = calendar.reminderPersist or true;
        allDayReminders = calendar.allDayReminders or false;
        allDayReminderTime = calendar.allDayReminderTime or "09:00";
        closeBehavior = calendar.closeBehavior or "minimize";
      };

      filesPolicy = {
        themeMode = duxFiles.themeMode or "auto";
        defaultView = duxFiles.defaultView or "list";
        showHidden = duxFiles.showHidden or false;
        foldersFirst = duxFiles.foldersFirst or true;
        confirmTrash = duxFiles.confirmTrash or false;
        terminal = duxFiles.terminal or "";
        registerFileManager = duxFiles.registerFileManager or true;
        recentFiles = duxFiles.recentFiles or true;
        searchExcludes = duxFiles.searchExcludes or [ ];
        defaultSort = duxFiles.defaultSort or "name";
        defaultSortDescending = duxFiles.defaultSortDescending or false;
        showTitleBar = duxFiles.showTitleBar or false;
        density = duxFiles.density or "comfortable";
        showExtensions = duxFiles.showExtensions or true;
        rememberFolderViews = duxFiles.rememberFolderViews or true;
        folderCounts = duxFiles.folderCounts or true;
        clickToOpen = duxFiles.clickToOpen or "double";
        thumbnails = duxFiles.thumbnails or true;
        thumbnailSizeLimitMb = duxFiles.thumbnailSizeLimitMb or 64;
        sidebarCollapsed = duxFiles.sidebarCollapsed or false;
        showDevicesSidebar = duxFiles.showDevicesSidebar or true;
        showNetworkSidebar = duxFiles.showNetworkSidebar or true;
        showGamesSidebar = duxFiles.showGamesSidebar or true;
        closeBehavior = duxFiles.closeBehavior or "quit";
        opener = duxFiles.opener or "";
        vimKeys = duxFiles.vimKeys or false;
      };
    in
    {
      imports = [
        inputs.ojuny-desktop.inputs.dux-search.homeModules.default
        inputs.ojuny-desktop.inputs.dux-calendar.homeModules.default
      ];

      config = {
        programs.dsearch = lib.mkIf (dsearch.enable or false) {
          enable = true;
          config = {
            http_enabled = dsearch.httpEnabled or false;
            max_file_bytes = dsearch.maxFileBytes or 2097152;
            worker_count = dsearch.workerCount or 4;
            index_all_files = true;
            index_paths = map (path: {
              inherit path;
              max_depth = dsearch.maxDepth or 6;
              exclude_hidden = dsearch.excludeHidden or true;
              extract_exif = dsearch.extractExif or true;
            }) (dsearch.indexPaths or [ "~" ]);
          };
        };

        programs.dank-calendar = lib.mkIf (calendar.enable or false) {
          enable = true;
        };

        home.activation.duxToolsSettings = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
          CALENDAR_POLICY=${lib.escapeShellArg (builtins.toJSON calendarPolicy)} \
          FILES_POLICY=${lib.escapeShellArg (builtins.toJSON filesPolicy)} \
            ${pkgs.python3}/bin/python3 - <<'PY'
          import json
          import os
          import pathlib
          import stat
          import sys
          import tempfile

          policies = {
              pathlib.Path(os.environ["HOME"]) / ".config/dankcal/ui-settings.json": json.loads(os.environ["CALENDAR_POLICY"]),
              pathlib.Path(os.environ["HOME"]) / ".config/dfiles/ui-settings.json": json.loads(os.environ["FILES_POLICY"]),
          }

          for path, policy in policies.items():
              try:
                  with path.open() as handle:
                      settings = json.load(handle)
              except FileNotFoundError:
                  settings = {}
              except (OSError, json.JSONDecodeError) as error:
                  print(f"dux-tools: keeping {path}: {error}", file=sys.stderr)
                  continue

              if not isinstance(settings, dict):
                  print(f"dux-tools: keeping {path}: not a JSON object", file=sys.stderr)
                  continue

              settings.update(policy)
              path.parent.mkdir(parents=True, exist_ok=True)
              mode = stat.S_IMODE(path.stat().st_mode) if path.exists() and not path.is_symlink() else 0o600
              mode |= stat.S_IWUSR
              descriptor, temporary = tempfile.mkstemp(dir=path.parent, prefix=path.name + ".", suffix=".tmp")
              try:
                  with os.fdopen(descriptor, "w") as handle:
                      json.dump(settings, handle, indent=2, sort_keys=True)
                      handle.write("\n")
                  os.chmod(temporary, mode)
                  os.replace(temporary, path)
              except BaseException:
                  os.unlink(temporary)
                  raise
          PY
        '';

        systemd.user.services.dgop = lib.mkIf (gop.enable or false) {
          Unit = {
            Description = "dgop system resource API";
            After = [ "network.target" ];
          };
          Service = {
            ExecStart = "${dgop}/bin/dgop server";
            Environment = "API_PORT=:${toString (gop.apiPort or 63484)}";
            Restart = "on-failure";
            RestartSec = "2";
          };
          Install.WantedBy = [ "default.target" ];
        };
      };
    };

}
