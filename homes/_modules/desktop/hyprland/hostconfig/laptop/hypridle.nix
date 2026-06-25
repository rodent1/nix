{
  config,
  lib,
  ...
}:
let
  cfg = config.modules.desktop.hyprland;
in
{
  config = lib.mkIf cfg.enable {
    services.hypridle = {
      enable = true; # Enable the idle management daemon for Hyprland

      settings = {
        general = {
          lock_cmd = "pidof hyprlock || hyprlock";
          before_sleep_cmd = "loginctl lock-session";
        };

        listener = [
          {
            timeout = 150; # 2.5min.
            on-timeout = "brightnessctl -s set 10"; # set monitor backlight to minimum, avoid 0 on OLED monitor.
            on-resume = "brightnessctl -r"; # monitor backlight restore.
          }
          {
            timeout = 300; # 5min
            on-timeout = "loginctl lock-session";
          }

          {
            timeout = 330; # 5.5min
            on-timeout = "hyprctl dispatch 'hl.dsp.dpms({ action = \"disable\" })'"; # screen off when timeout has passed
            on-resume = "hyprctl dispatch 'hl.dsp.dpms({ action = \"enable\" })' && brightnessctl -r"; # screen on when activity is detected after timeout has fired.
          }
          {
            timeout = 600; # 10min
            on-timeout = "systemctl suspend";
          }
        ];
      };
    };
  };
}
