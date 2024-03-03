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
    # Home manager
    inputs.home-manager.nixosModules.home-manager
    # Machine config
    ./hardware-configuration.nix
    ./../common/default.nix
    ./../common/optional/wsl.nix
    ./../common/users
    ./../common/users/stianrs
    # User config
    ./../../home-manager/home.nix
  ];


  networking.hostName = "laptop";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.11";
}
