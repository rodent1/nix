{
  internal.homeModules.desktop =
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
          hl.on("hyprland.start", function ()
            hl.exec_cmd("1password --silent")
            hl.exec_cmd("vesktop")
          end)
        '';
      };
    };
}
