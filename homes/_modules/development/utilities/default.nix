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
      unstable.nixd
      nixfmt-rfc-style
      nix-init
      nix-inspect
      nodePackages.prettier
      pre-commit
      shellcheck
      shfmt
      terraform
      yamllint
    ];
  };
}
