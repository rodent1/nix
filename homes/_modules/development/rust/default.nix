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
      with pkgs;
      [
        rust-bin.stable.latest.default # Rust-overlay stable
      ]
    );
  };
}
