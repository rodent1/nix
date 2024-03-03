{ inputs, pkgs, ... }:
{
  imports = [
    inputs.nixos-wsl.nixosModules.default
  ];

  wsl = {
    enable = true;
    defaultUser = "stianrs";
  };

  programs.nix-ld = {
    enable = true;
  };
}
