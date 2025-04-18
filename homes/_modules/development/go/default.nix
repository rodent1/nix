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
      go
      gotools
      golangci-lint
    ];
  };
}
