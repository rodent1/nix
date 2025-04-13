{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.modules.shell.starship;
in
{
  options.modules.shell.starship = {
    enable = lib.mkEnableOption "starship";
  };

  config = lib.mkIf cfg.enable {
    programs.starship = {
      enable = true;
      package = pkgs.starship;
    };

    catppuccin.starship.enable = true;
  };
}
