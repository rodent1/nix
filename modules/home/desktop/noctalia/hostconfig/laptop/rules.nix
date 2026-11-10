{
  internal.homeModules.laptop =
    {
      osConfig,
      lib,
      ...
    }:
    {
      config = lib.mkIf osConfig.modules.desktop.enable {
        wayland.windowManager.hyprland.extraConfig = ''
          hl.workspace_rule({
            workspace = "name:Discord",
            persistent = true,
          })
        '';
      };
    };
}
