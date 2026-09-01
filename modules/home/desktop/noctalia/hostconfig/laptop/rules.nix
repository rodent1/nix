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
          hl.workspace_rule({
            workspace = "1",
            default_name = "Discord",
            monitor = "eDP-1",
            persistent = true,
            gaps_in = 0,
            gaps_out = 0,
            no_rounding = true,
            no_border = true,
            decorate = false,
          })
        '';
      };
    };
}
