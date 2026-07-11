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
    inputs.opnix.homeManagerModules.default
  ];

  mkHost =
    hostname:
    { system, isWSL }:
    withSystem system (
      { pkgs, ... }:
      inputs.nixpkgs.lib.nixosSystem {
        inherit pkgs system;
        modules = [
          {
            nixpkgs.hostPlatform = system;
            networking.hostName = hostname;
          }
          inputs.catppuccin.nixosModules.catppuccin
          inputs.home-manager.nixosModules.home-manager
          inputs.nix-index-database.nixosModules.nix-index
          inputs.opnix.nixosModules.default
          {
            home-manager = {
              sharedModules = sharedHomeModules;
              useUserPackages = true;
              useGlobalPkgs = true;
              users.stianrs = {
                imports = [
                  config.rodent.homeModules.default
                  (lib.attrByPath [ hostname ] { } config.rodent.homeModules)
                ]
                ++ lib.optionals (!isWSL) [ config.rodent.homeModules.desktop ];
                rodent = {
                  hostName = hostname;
                  inherit isWSL;
                };
              };
            };
          }
          config.rodent.nixosModules.default
          config.rodent.nixosModules.${hostname}
        ]
        ++ lib.optionals isWSL [
          inputs.nixos-wsl.nixosModules.default
          config.rodent.nixosModules.wsl
        ];
      }
    );
in
{
  flake.nixosConfigurations = lib.mapAttrs mkHost config.rodent.hosts;
}
