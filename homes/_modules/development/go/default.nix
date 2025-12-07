{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.modules.development.go;
in
{
  options.modules.development.go = {
    enable = lib.mkEnableOption "go";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      gotools
      golangci-lint
      wails3
    ];

    programs.go = {
      enable = true;
    };
  };
}
