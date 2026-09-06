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
            workspace = "name:Discord",
            persistent = true,
          })
        '';
      };
    };
}
