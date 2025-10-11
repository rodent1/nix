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
    home.packages = with pkgs; [
      nodejs_24
      unstable.bun
    ];
  };
}
