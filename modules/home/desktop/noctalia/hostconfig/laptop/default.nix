{
  internal.homeModules.laptop =
    {
      osConfig,
      lib,
      ...
    }:
    {
      config = lib.mkIf osConfig.modules.desktop.enable {
        programs.noctalia.settings.idle.behavior."lock-and-suspend" = {
          enabled = true;
          timeout = 900;
          action = "lock_and_suspend";
        };

        wayland.windowManager.hyprland.extraConfig = ''
          hl.monitor({ output = "eDP-1", cm = "auto", scale = 1.5 })
          -- Avoid fullscreen HDR mode switches that cause flashing and incorrect colors.
          hl.config({ render = { cm_auto_hdr = 0 } })
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
