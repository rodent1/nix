{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.modules.development;
in {
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      alejandra
      nixd
      nix-init
      nodePackages.prettier
      pre-commit
      shellcheck
      shfmt
      terraform
      yamllint
    ];
  };
}
