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
            networking.hostName = lib.mkDefault hostname;
          }
          inputs.catppuccin.nixosModules.catppuccin
          inputs.home-manager.nixosModules.home-manager
          inputs.nix-index-database.nixosModules.nix-index
          {
            home-manager = {
              sharedModules = sharedHomeModules;
              useUserPackages = true;
              useGlobalPkgs = true;
              users.stianrs = {
                imports = [
                  config.internal.homeModules.default
                  config.internal.homeModules.stianrs
                  (lib.attrByPath [ hostname ] { } config.internal.homeModules)
                ]
                ++ lib.optionals (!isWSL) [ config.internal.homeModules.desktop ];
                host = {
                  name = hostname;
                  inherit isWSL;
                };
              };
            };
          }
          config.internal.nixosModules.default
          config.internal.nixosModules.${hostname}
        ]
        ++ lib.optionals isWSL [
          inputs.nixos-wsl.nixosModules.default
          config.internal.nixosModules.wsl
        ];
      }
    );
in
{
  flake.nixosConfigurations = lib.mapAttrs mkHost config.internal.hosts;
}
