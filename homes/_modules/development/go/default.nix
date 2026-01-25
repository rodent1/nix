{
  config,
  lib,
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
    programs.go = {
      enable = true;
      env.GOPATH = "${config.home.homeDirectory}/.go";
    };

    home.sessionPath = [
      "${config.home.homeDirectory}/.go/bin"
    ];
  };
}
