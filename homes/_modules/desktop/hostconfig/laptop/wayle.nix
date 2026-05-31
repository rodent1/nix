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
            right = [
              "systray"
              "network"
              "volume"
              "custom-brightness"
              "battery"
              "notifications"
              "dashboard"
            ];
          }
        ];
      };
    };
  };
}
