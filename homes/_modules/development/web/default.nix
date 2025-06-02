{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.modules.development;

  # Override pnpm to use specific Node.js version
  pnpm-with-custom-node = pkgs.unstable.pnpm.override {
    nodejs = pkgs.unstable.nodejs_24;
  };
in
{
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs.unstable; [
      biome
      bun
      nodejs_24
      pnpm-with-custom-node
      turbo
    ];
  };
}
