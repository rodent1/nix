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
    programs.steam.enable = true;

    environment.systemPackages = with pkgs; [
      bottles
      faugus-launcher
      wagoapp
    ];
  };
}
