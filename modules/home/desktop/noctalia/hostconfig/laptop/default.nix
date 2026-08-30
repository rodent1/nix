{
  internal.homeModules.laptop =
    {
      config,
      lib,
      ...
    }:
    let
      cfg = config.modules.desktop.noctalia;
    in
    {
      config = lib.mkIf cfg.enable {
        programs.noctalia.settings.idle.behavior."lock-and-suspend" = {
          enabled = true;
          timeout = 900;
          action = "lock_and_suspend";
        };

        wayland.windowManager.hyprland.extraConfig = ''
          hl.monitor({ output = "eDP-1", mode = "preferred", position = "auto", scale = 1.5 })

          -- unscale XWayland
          hl.config({
            xwayland = {
              force_zero_scaling = true
            }
          })
        '';

        programs.noctalia.settings.brightness = {
          minimum_brightness = 0.01;
          monitor.eDP-1 = {
            backend = "backlight";
            backlight_device = "intel_backlight";
          };
        };
      };
    };
}
