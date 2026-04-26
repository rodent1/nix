{
  config,
  lib,
  ...
}:
let
  cfg = config.modules.desktop.noctalia;
in
{
  options.modules.desktop.noctalia = {
    enable = lib.mkEnableOption "noctalia shell";
  };

  config = lib.mkIf cfg.enable {
    programs.noctalia-shell = {
      enable = true;

      settings = {
        general = {
          avatarImage = "/home/${config.home.username}/.face";
        };

        colorSchemes.predefinedScheme = "Catppuccin";
      };
    };
  };
}
