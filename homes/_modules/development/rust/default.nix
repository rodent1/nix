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
    home.packages =
      (with pkgs; [
        (fenix.stable.withComponents [
          "cargo"
          "clippy"
          "rust-src"
          "rustc"
          "rustfmt"
        ])
      ])
      ++ (with pkgs.unstable; [
        rust-analyzer
      ]);

    home.sessionPath = [
      "${config.home.homeDirectory}/.cargo/bin"
    ];
  };
}
