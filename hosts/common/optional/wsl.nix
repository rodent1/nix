{ inputs, pkgs, ... }:
{

  nixpkgs.overlays = [
    inputs.nix-ld-rs.overlays.default
  ];

  imports = [
    inputs.nixos-wsl.nixosModules.default
    inputs.vscode-server.nixosModules.default
  ];

  wsl = {
    enable = true;
    defaultUser = "stianrs";
    startMenuLaunchers = true;
    wslConf.automount.root = "/mnt";
  };

  programs.nix-ld = {
    enable = true;
    package = pkgs.nix-ld-rs;
  };
  services.vscode-server.enable = true;
}
