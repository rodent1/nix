{
  config,
  inputs,
  lib,
  withSystem,
  ...
}:
let
  sharedHomeModules = [
    inputs.catppuccin.homeModules.catppuccin
    inputs.nix-index-database.homeModules.nix-index
    inputs.noctalia.homeModules.default
    inputs.opnix.homeManagerModules.default
  ];

  mkHost =
    hostname:
    { system }:
    withSystem system (
      { pkgs, ... }:
      inputs.nixpkgs.lib.nixosSystem {
        inherit pkgs system;
        modules = [
          {
            nixpkgs.hostPlatform = system;
            networking.hostName = lib.mkDefault hostname;
          }
          inputs.catppuccin.nixosModules.catppuccin
          inputs.home-manager.nixosModules.home-manager
          inputs.nix-index-database.nixosModules.nix-index
          # Inert until a host sets wsl.enable; imported everywhere so the option always exists.
          inputs.nixos-wsl.nixosModules.default
          inputs.noctalia.nixosModules.default
          inputs.noctalia-greeter.nixosModules.default
          {
            home-manager = {
              sharedModules = sharedHomeModules;
              useUserPackages = true;
              useGlobalPkgs = true;
              users.stianrs = {
                imports = [
                  config.internal.homeModules.default
                  config.internal.homeModules.stianrs
                ];
              };
            };
          }
          config.internal.nixosModules.default
          config.internal.nixosModules.${hostname}
        ];
      }
    );
in
{
  flake.nixosConfigurations = lib.mapAttrs mkHost config.internal.hosts;
}
