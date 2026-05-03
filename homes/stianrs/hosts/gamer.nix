_: {
  config = {
    modules = {
      desktop = {
        enable = true;
        noctalia.enable = true;
      };
      kubernetes.enable = true;
      development.go.enable = false;
      development.rust.enable = false;
    };

    programs.niri.settings = {
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

      workspaces."1".open-on-output = "DP-2";
      workspaces."2".open-on-output = "DP-2";
      workspaces."3".open-on-output = "DP-3";
      workspaces."4".open-on-output = "DP-2";
      workspaces."5".open-on-output = "DP-1";
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
