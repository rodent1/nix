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
