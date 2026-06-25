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
              "brightness"
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
