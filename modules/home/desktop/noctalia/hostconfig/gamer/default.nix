{
  internal.homeModules.gamer =
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
          hl.monitor({ output = "DP-2", mode = "highrr", position = "0x0", scale = 1 })
          hl.monitor({ output = "DP-1", mode = "highrr", position = "0x1440", scale = 1, vrr = 1 })
          hl.monitor({ output = "DP-3", mode = "highrr", position = "2560x1189", scale = 1, transform = 3 })
          hl.monitor({ output = "", mode = "preferred", position = "auto", scale = 1 })
        '';

        programs.noctalia.settings.bar.default.monitor.DP-3.enabled = false;
      };
    };
}
