{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.modules.development.rust;
  rustlings = pkgs.rustlings.override {
    inherit (pkgs.fenix.stable) cargo clippy rustc;
  };
in
{
  options.modules.development.rust = {
    enable = lib.mkEnableOption "rust";
  };

  config = lib.mkIf cfg.enable {
    home.packages =
      (with pkgs; [
        (fenix.stable.withComponents [
          "cargo"
          "clippy"
          "rust-src"
          "rustc"
          "rustfmt"
        ])
        rustlings
      ])
      ++ (with pkgs.unstable; [
        rust-analyzer
      ]);
  };
}
