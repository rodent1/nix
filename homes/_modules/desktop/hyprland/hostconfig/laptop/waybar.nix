_: {
  config = {
    services.wayle.settings = {
      bar = {
        layout = [
          {
            left = [
              "dashboard"
              "hyprland-workspaces"
            ];
            center = [
              "clock"
              "separator"
              "weather"
            ];
            monitor = "*";
            right = [
              "systray"
              "network"
              "volume"
              "battery"
              "notifications"
            ];
            show = true;
          }
        ];
      };

      modules = {
        clock = {
          format = "%d %b, %H:%M";
          icon-show = false;
        };
        weather = {
          format = "{{ temp }}{{ temp_unit }} {{ condition }}";
          icon-show = false;
          location = "Forsand";
          time-format = "24h";
        };
      };

      styling = {
        palette = {
          bg = "#11111b";
          blue = "#74c7ec";
          elevated = "#1e1e2e";
          fg = "#cdd6f4";
          fg-muted = "#bac2de";
          green = "#a6e3a1";
          primary = "#b4befe";
          red = "#f38ba8";
          surface = "#181825";
          yellow = "#f9e2af";
        };
      };
    };
  };
}
