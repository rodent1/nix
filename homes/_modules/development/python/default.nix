{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.modules.development;
in
{
  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.python313
      pkgs.unstable.uv
    ];
  };
}
