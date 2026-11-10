{
  internal.homeModules.gamer =
    {
      osConfig,
      lib,
      ...
    }:
    {
      config = lib.mkIf osConfig.modules.desktop.enable {
        programs.noctalia.settings.idle.behavior."lock-and-suspend" = {
          enabled = false;
          timeout = 900;
          action = "lock_and_suspend";
        };

        wayland.windowManager.hyprland.extraConfig = ''
          hl.monitor({ output = "DP-1", cm = "auto", mode = "highrr", position = "0x1440", scale = 1, vrr = 3})
          hl.monitor({ output = "DP-2", cm = "auto", mode = "highrr", position = "0x0", scale = 1 })
          hl.monitor({ output = "DP-3", cm = "auto", mode = "highrr", position = "2560x1189", scale = 1, transform = 3 })
          hl.monitor({ output = "", mode = "preferred", position = "auto", scale = 1 })
          -- Avoid fullscreen HDR mode switches that cause flashing and incorrect colors.
          hl.config({ render = { cm_auto_hdr = 0 } })
        '';

        programs.noctalia.settings.bar.default.monitor.DP-3.enabled = false;
      };
    };
}
