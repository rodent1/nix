{
  rodent.homeModules.gamer =
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
    };
}
