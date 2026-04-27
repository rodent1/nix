_:
{
  config = {
    modules = {
      desktop = {
        enable = true;
        noctalia.enable = true;
      };
      kubernetes.enable = false;
      development.go.enable = false;
      development.rust.enable = false;
    };

    programs.niri.settings = {
      outputs = {
        "DP-1" = {
          enable = true;
          position = {
            x = 0;
            y = -1440;
          };
        };
        "DP-2" = {
          enable = true;
          focus-at-startup = true;
          position = {
            x = 0;
            y = -0;
          };
        };
        "DP-3" = {
          enable = true;
          transform = {
            rotation = 270;
          };
          position = {
            x = 2560;
            y = -200;
          };
        };
      };

      workspaces = {
        "main" = {
          open-on-output = "DP-2";
        };
        "browser" = {
          open-on-output = "DP-2";
        };
        "discord" = {
          open-on-output = "DP-3";
        };
        "high" = {
          open-on-output = "DP-1";
        };
      };
    };

    programs.noctalia-shell.settings = {
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

    home.file.".face".source = ../assets/profile.jpg;
  };
}
