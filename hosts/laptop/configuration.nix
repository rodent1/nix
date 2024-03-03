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
    # If you want to use modules your own flake exports (from modules/nixos):
    # outputs.nixosModules.example

    # Or modules from other flakes (such as nixos-hardware):
    # inputs.hardware.nixosModules.common-cpu-amd
    # inputs.hardware.nixosModules.common-ssd

    # You can also split up your configuration and import pieces of it here:
    # ./users.nix

    inputs.home-manager.nixosModules.home-manager
    ../../common/default.nix
    ./../common/optional/wsl.nix
    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix
  ];


  networking.hostName = "laptop";

  # TODO: Move to dedicated user settings

  users.users = {
    stianrs = {
      isNormalUser = true;
      extraGroups = ["wheel"];
    };
  };

  home-manager = {
    extraSpecialArgs = { inherit inputs outputs; };
    users = {
      # Import your home-manager configuration
      stianrs = import ../../home-manager/home.nix;
    };
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.11";
}
