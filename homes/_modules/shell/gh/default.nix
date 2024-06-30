{ pkgs, flake-packages, ... }:
{

  config = {
    programs.gh = {
      enable = true;
      extensions = [
        flake-packages.${pkgs.system}.gh-copilot
        flake-packages.${pkgs.system}.gh-tidy
      ];
    };
  };
}
