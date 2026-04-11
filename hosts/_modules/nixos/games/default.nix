{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.modules.games;
in
{
  options.modules.games = {
    enable = lib.mkEnableOption "games";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.faugus-launcher
      pkgs.wagoapp
    ];
  };
}
