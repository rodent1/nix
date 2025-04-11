{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.modules.development.rust;
in
{
  options.modules.development.rust = {
    enable = lib.mkEnableOption "rust";
  };

  config = lib.mkIf cfg.enable {
    home.packages = (
      with pkgs.unstable;
      [
        (fenix.stable.withComponents [
          "cargo"
          "clippy"
          "rust-src"
          "rustc"
          "rustfmt"
        ])
        rust-analyzer-nightly
      ]
    );
  };
}
