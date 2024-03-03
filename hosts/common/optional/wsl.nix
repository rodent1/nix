{ inputs, pkgs, ... }:
{
  imports = [
    inputs.nixos-wsl.nixosModules.default
    inputs.vscode-server.nixosModules.default
  ];

  wsl = {
    enable = true;
    defaultUser = "stianrs";
  };

  programs.nix-ld = {
    enable = true;
  };
  services.vscode-server = {
    enable = true;
    nodejsPackage = pkgs.nodejs_20;
  };
}
