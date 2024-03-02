{ inputs, config, lib, pkgs, ... }:
{
  imports = [
    # Import WSL's NixOS module
    inputs.nixos-wsl.nixosModules.wsl
  ];

  wsl = {
    enable = true;
    defaultUser = "stianrs";
    startMenuLaunchers = true;
    wslConf.automount.root = "/mnt";
  };
}
