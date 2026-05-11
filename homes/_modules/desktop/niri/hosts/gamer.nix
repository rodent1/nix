_: {
  config = {
    modules.desktop.niri.settings = {
      outputs = {
        "DP-1" = {
          enable = true;
          mode = {
            width = 2560;
            height = 1440;
            refresh = 143.912;
          };

          position = {
            x = 0;
            y = -1440;
          };
        };

        "DP-2" = {
          enable = true;
          mode = {
            width = 2560;
            height = 1440;
            refresh = 165.069;
          };

          position = {
            x = 0;
            y = -0;
          };

          variable-refresh-rate = "on-demand";
          focus-at-startup = true;
        };

        "DP-3" = {
          enable = true;
          mode = {
            width = 1920;
            height = 1080;
            refresh = 143.980;
          };

          position = {
            x = 2560;
            y = -200;
          };

          transform = {
            rotation = 270;
          };
        };
      };

      workspaces = {
        "1" = {
          name = "browser";
          open-on-output = "DP-2";
        };
        "2" = {
          name = "main";
          open-on-output = "DP-2";
        };
        "3" = {
          name = "discord";
          open-on-output = "DP-3";
        };
        "4" = {
          name = "games";
          open-on-output = "DP-2";
        };
        "5" = {
          name = "high";
          open-on-output = "DP-1";
        };
      };
    };

    modules.desktop.niri.noctalia.settings = {
      general = {
        lockScreenMonitors = [ "DP-2" ];
      };

      notifications = {
        monitors = [ "DP-2" ];
      };

      osd = {
        monitors = [ "DP-2" ];
      };
    };
  };
}
