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
      cue
      nixd
      nodePackages.prettier
      pre-commit
      shellcheck
      shfmt
      yamllint
    ];
  };
}
