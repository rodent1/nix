{ config, pkgs, ... }:
let
  weatherScript = "${config.xdg.configHome}/waybar/scripts/get_weather.sh";
in
{
  config = {
    programs.waybar = {
      enable = true;
      systemd.enable = true;

      settings = {
        mainBar = {
          layer = "top";
          position = "top";
          mode = "dock";
          height = 36;
          exclusive = true;
          passthrough = false;
          gtk-layer-shell = true;
          ipc = true;
          fixed-center = true;
          margin-top = 20;
          margin-left = 20;
          margin-right = 20;
          margin-bottom = 0;

          modules-left = [
            "hyprland/workspaces"
          ];
          modules-center = [
            "clock"
            "custom/weather"
          ];
          modules-right = [
            "pulseaudio"
            "custom/mem"
            "backlight"
            "battery"
            "tray"
          ];

          "hyprland/workspaces" = {
            active-only = false;
            sort-by-number = true;
          };

          "clock" = {
            tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
            format = "{:%a, %d %b, %I:%M %p}";
          };

          "custom/weather" = {
            format = "{}";
            tooltip = true;
            interval = 1800;
            exec = "${weatherScript} Forsand+Sandnes";
            return-type = "json";
          };

          "pulseaudio" = {
            format = "{volume}% {icon}";
            format-bluetooth = "{volume}% {icon}";
            format-muted = "";
            format-icons = {
              headphone = "";
              hands-free = "";
              headset = "";
              phone = "";
              phone-muted = "";
              portable = "";
              car = "";
              default = "";
            };
            scroll-step = 1;
            on-click = "pavucontrol";
          };

          "custom/mem" = {
            format = "{} 󰍛";
            interval = 3;
            exec = "free -h | awk '/Mem:/{printf $3}'";
            tooltip = false;
          };

          "backlight" = {
            format = "{icon} {percent}%";
            format-icons = [
              ""
              ""
              ""
              ""
              ""
              ""
              ""
              ""
              ""
            ];
            on-scroll-up = "${pkgs.brightnessctl}/bin/brightnessctl set 2%+";
            on-scroll-down = "${pkgs.brightnessctl}/bin/brightnessctl set 2%-";
          };

          "battery" = {
            states = {
              warning = 30;
              critical = 15;
            };
            format = "{capacity}% {icon}";
            format-icons = {
              default = [
                "󱊤"
                "󰁺"
                "󰁻"
                "󰁼"
                "󰁽"
                "󰁾"
                "󰁿"
                "󰂀"
                "󰂁"
                "󰂂"
                "󱊣"
              ];
              charging = [
                "󱊤"
                "󰢜"
                "󰂆"
                "󰂇"
                "󰂈"
                "󰢝"
                "󰂉"
                "󰢞"
                "󰂊"
                "󰂋"
                "󰂄"
              ];
            };

            "tray" = {
              icon-size = 16;
              spacing = 0;
            };
          };
        };
      };

      style = ''
        * {
            border: none;
            border-radius: 0;
            /* `otf-font-awesome` is required to be installed for icons */
            font-family: Liberation Mono;
            min-height: 20px;
        }

        window#waybar {
            background: transparent;
        }

        window#waybar.hidden {
            opacity: 0.2;
        }

        #workspaces {
            margin-right: 8px;
            border-radius: 10px;
            transition: none;
            background: #383c4a;
        }

        #workspaces button {
            transition: none;
            color: #7c818c;
            background: transparent;
            padding: 5px;
            font-size: 18px;
        }

        #workspaces button.persistent {
            color: #7c818c;
            font-size: 12px;
        }

        /* https://github.com/Alexays/Waybar/wiki/FAQ#the-workspace-buttons-have-a-strange-hover-effect */
        #workspaces button:hover {
            transition: none;
            box-shadow: inherit;
            text-shadow: inherit;
            border-radius: inherit;
            color: #383c4a;
            background: #7c818c;
        }

        #workspaces button.focused {
            color: white;
        }

        #language {
            padding-left: 16px;
            padding-right: 8px;
            border-radius: 10px 0px 0px 10px;
            transition: none;
            color: #ffffff;
            background: #383c4a;
        }

        #keyboard-state {
            margin-right: 8px;
            padding-right: 16px;
            border-radius: 0px 10px 10px 0px;
            transition: none;
            color: #ffffff;
            background: #383c4a;
        }

        #custom-pacman {
            padding-left: 16px;
            padding-right: 8px;
            border-radius: 10px 0px 0px 10px;
            transition: none;
            color: #ffffff;
            background: #383c4a;
        }

        #custom-mail {
            margin-right: 8px;
            padding-right: 16px;
            border-radius: 0px 10px 10px 0px;
            transition: none;
            color: #ffffff;
            background: #383c4a;
        }

        #mode {
            padding-left: 16px;
            padding-right: 16px;
            border-radius: 10px;
            transition: none;
            color: #ffffff;
            background: #383c4a;
        }

        #clock {
            padding-left: 16px;
            padding-right: 16px;
            border-radius: 10px 0px 0px 10px;
            transition: none;
            color: #ffffff;
            background: #383c4a;
        }

        #custom-weather {
            padding-right: 16px;
            border-radius: 0px 10px 10px 0px;
            transition: none;
            color: #ffffff;
            background: #383c4a;
        }

        #pulseaudio {
            margin-right: 8px;
            padding-left: 16px;
            padding-right: 16px;
            border-radius: 10px;
            transition: none;
            color: #ffffff;
            background: #383c4a;
        }

        #pulseaudio.muted {
            background-color: #90b1b1;
            color: #2a5c45;
        }

        #custom-mem {
            margin-right: 8px;
            padding-left: 16px;
            padding-right: 16px;
            border-radius: 10px;
            transition: none;
            color: #ffffff;
            background: #383c4a;
        }

        #temperature {
            margin-right: 8px;
            padding-left: 16px;
            padding-right: 16px;
            border-radius: 10px;
            transition: none;
            color: #ffffff;
            background: #383c4a;
        }

        #temperature.critical {
            background-color: #eb4d4b;
        }

        #backlight {
            margin-right: 8px;
            padding-left: 16px;
            padding-right: 16px;
            border-radius: 10px;
            transition: none;
            color: #ffffff;
            background: #383c4a;
        }

        #battery {
            margin-right: 8px;
            padding-left: 16px;
            padding-right: 16px;
            border-radius: 10px;
            transition: none;
            color: #ffffff;
            background: #383c4a;
        }

        #battery.charging {
            color: #ffffff;
            background-color: #26A65B;
        }

        #battery.warning:not(.charging) {
            background-color: #ffbe61;
            color: black;
        }

        #battery.critical:not(.charging) {
            background-color: #f53c3c;
            color: #ffffff;
            animation-name: blink;
            animation-duration: 0.5s;
            animation-timing-function: linear;
            animation-iteration-count: infinite;
            animation-direction: alternate;
        }

        #tray {
            padding-left: 16px;
            padding-right: 16px;
            border-radius: 10px;
            transition: none;
            color: #ffffff;
            background: #383c4a;
        }

        @keyframes blink {
            to {
                background-color: #ffffff;
                color: #000000;
            }
        }
      '';
    };
  };
}
