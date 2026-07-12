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
        programs.hyprlock.enable = true;

        catppuccin.hyprlock = {
          enable = true;
          useDefaultConfig = false;
        };
      };
    };
}
