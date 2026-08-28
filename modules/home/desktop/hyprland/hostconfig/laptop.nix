{
  internal.homeModules.laptop =
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
        wayland.windowManager.hyprland.extraConfig = ''
          hl.monitor({
            output = "eDP-1",
            mode = "2880x1800@60",
            position = "0x0",
            scale = 1.6,
            bitdepth = 10,
            cm = "hdr",
          })
        '';
      };
    };
}
