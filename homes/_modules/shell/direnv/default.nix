{
  lib,
  config,
  ...
}:
let
  cfg = config.modules.shell.direnv;
in {
  options.modules.shell.direnv = {
    enable = lib.mkEnableOption "direnv";
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      programs.direnv = {
        enable = true;
      };
    })
  ];
}
