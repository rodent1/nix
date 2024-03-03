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
    # User config
    ./../../home-manager/home.nix
  ];


  networking.hostName = "gamer";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.11";
}
