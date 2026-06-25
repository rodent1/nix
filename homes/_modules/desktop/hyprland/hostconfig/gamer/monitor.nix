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
    wayland.windowManager.hyprland = {
      extraConfig = ''
        hl.monitor({
            output = "DP-1",
            mode = "highrr",
            position = "2560x-0",
            scale = 1,
            vrr = 1
          })

        hl.monitor({
            output = "DP-2",
            mode = "highrr",
            position = "2560x-1450",
            scale = 1,
          })

        hl.monitor({
            output = "DP-3",
            mode = "highrr",
            position = "5130x-230",
            scale = 1,
            transform = 3
          })
      '';
    };
  };
}
