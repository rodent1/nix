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
    home.packages =
      (with pkgs; [
        # Development tools
        act
        deadnix
        nix-init
        nix-inspect
        nvfetcher
        pre-commit

        # Formatting and linting
        nixfmt-rfc-style
        nodePackages.prettier
        shellcheck
        shfmt
        statix
        yamllint
      ])
      ++ (with pkgs.unstable; [ nixd ]);
  };
}
