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
  options.modules.development.nix = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable Nix development tools and utilities.";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      deadnix
      nix-init
      nix-inspect
      nixd
      nixfmt
      nvfetcher
      statix
    ];
  };
}
