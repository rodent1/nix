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
    home.packages = (
      with pkgs;
      [
        deadnix
        nix-init
        nix-inspect
        nixd
        nvfetcher
        statix
      ]
      ++ (with pkgs.unstable; [
        nixfmt-rfc-style
      ])
    );
  };
}
