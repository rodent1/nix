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
        wayland.windowManager.hyprland.extraConfig = ''
          hl.monitor({ output = "eDP-1", mode = "preferred", position = "auto", scale = 1.5 })

          -- brightness keys
          hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("noctalia msg brightness-up eDP-1 5"), { locked = true, repeating = true })
          hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("noctalia msg brightness-down eDP-1 5"), { locked = true, repeating = true })
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
