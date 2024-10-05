{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.modules.development;
in
{
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      act
      unstable.nixd
      nixfmt-rfc-style
      nix-init
      nix-inspect
      nvfetcher
      nodePackages.prettier
      pre-commit
      shellcheck
      shfmt
      terraform
      yamllint
    ];
  };
}
