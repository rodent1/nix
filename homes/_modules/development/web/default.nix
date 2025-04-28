{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.modules.development;

  # Override pnpm to use specific Node.js version
  pnpm-with-custom-node = pkgs.pnpm_10.override {
    nodejs = pkgs.nodejs_23;
  };
in
{
  config = lib.mkIf cfg.enable {
    home.packages =
      (with pkgs; [
        chromium
        nodejs_23
        pnpm-with-custom-node
      ])
      ++ (with pkgs.unstable; [
        turbo
        bun
      ]);
  };
}
