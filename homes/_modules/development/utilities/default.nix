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
    home.packages = (
      with pkgs;
      [
        # Development tools
        act
        bun
        deadnix
        go
        go-tools
        nix-init
        nix-inspect
        nixd
        nodejs
        nvfetcher
        pre-commit
        python3
        rust-bin.stable.latest.default # Rust-overlay stable

        # Formatting and linting
        nixfmt-rfc-style
        nodePackages.prettier
        shellcheck
        shfmt
        statix
        yamllint
      ]
    );
  };
}
