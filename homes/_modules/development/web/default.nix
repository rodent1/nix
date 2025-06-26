{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.modules.development;

  # Override pnpm to use specific Node.js version
  pnpm-with-custom-node = pkgs.pnpm.override {
    nodejs = pkgs.nodejs_24;
  };
in
{
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      nodejs_24
      pnpm-with-custom-node
      turbo
      unstable.biome
      unstable.bun
    ];
  };
}
