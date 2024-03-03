{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # You can import other NixOS modules here
  imports = [
    inputs.home-manager.nixosModules.home-manager
    ./../common/default.nix
    ./../common/optional/wsl.nix
    ./../common/users
    ./../common/users/stianrs
    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix
  ];


  networking.hostName = "gamer";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.11";
}
