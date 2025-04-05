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
      biome
      eslint
      nodejs_23
      nodePackages.prettier
      pnpm_10
      turbo
    ];

  };
}
