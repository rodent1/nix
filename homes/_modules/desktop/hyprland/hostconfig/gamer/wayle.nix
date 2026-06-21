_: {
  config = {
    services.wayle.settings = {
      bar = {
        layout = [
          {
            left = [
              "hyprland-workspaces"
            ];
            center = [
              "clock"
              "weather"
            ];
            monitor = "*";
            right = [
              "systray"
              "volume"
              "notifications"
              "dashboard"
            ];
          }
          {
            monitor = "DP-3";
            show = false;
          }
        ];
      };
    };
  };
}
