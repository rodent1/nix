{ pkgs, ... }:
{
  config = {
    services.wayle = {
      enable = true;
      package = pkgs.unstable.wayle;

      settings = {
        bar = {
          button-variant = "basic";
        };

        modules = {
          clock = {
            format = "%d %b, %H:%M";
            icon-show = false;
          };
          custom = [
            {
              id = "brightness";
              interval-ms = 2000;
              command = ''
                brightnessctl -m | awk -F, '{
                  gsub(/%/, "", $4)
                  printf "{\"percentage\":%s,\"value\":\"%s%%\"}\n", $4, $4
                }'
              '';
              on-action = ''
                brightnessctl -m | awk -F, '{
                  gsub(/%/, "", $4)
                  printf "{\"percentage\":%s,\"value\":\"%s%%\"}\n", $4, $4
                }'
              '';
              format = "{{ value }}";
              tooltip-format = "Brightness {{ value }}";
              icon-name = "display-brightness-symbolic";
              scroll-up = "brightnessctl -e4 -n2 set 1%-";
              scroll-down = "brightnessctl -e4 -n2 set 1%+";
            }
          ];
          dashboard = {
            dropdown-lock-command = "hyprlock";
            dropdown-logout-command = "uwsm-app -- hyprshutdown -t 'Logging out...'";
            dropdown-reboot-command = "systemctl reboot";
            dropdown-poweroff-command = "systemctl poweroff";
          };
          hyprland-workspaces = {
            label-use-name = true;
          };
          notification = {
            label-show = false;
          };
          volume = {
            right-click = "pavucontrol";
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
  };
}
