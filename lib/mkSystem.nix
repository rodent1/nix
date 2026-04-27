{
  inputs,
  mkPkgsWithSystem,
  ...
}:
let
  sharedModules = [
    inputs.catppuccin.homeModules.catppuccin
    inputs.nix-index-database.homeModules.nix-index
    inputs.niri.homeModules.niri
    inputs.noctalia.homeModules.default
    inputs.opnix.homeManagerModules.default
  ];
in
{
  mkNixosSystem =
    system: hostname:
    inputs.nixpkgs.lib.nixosSystem {
      inherit system;
      pkgs = mkPkgsWithSystem system;
      modules = [
        {
          nixpkgs.hostPlatform = system;
          _module.args = {
            inherit inputs system;
          };
        }
        inputs.home-manager.nixosModules.home-manager
        inputs.nix-index-database.nixosModules.nix-index
        inputs.noctalia.nixosModules.default
        inputs.opnix.nixosModules.default
        {
          environment.pathsToLink = [
            "/share/applications"
            "/share/xdg-desktop-portal"
          ];

          home-manager = {
            inherit sharedModules;
            useUserPackages = true;
            useGlobalPkgs = true;
            extraSpecialArgs = {
              inherit inputs hostname system;
              isWSL = false;
            };
            users.stianrs = ../. + "/homes/stianrs";
          };
        }
        ../hosts/_modules/common
        ../hosts/_modules/nixos
        ../hosts/${hostname}
      ];
      specialArgs = {
        inherit inputs hostname;
      };
    };

  mkWslSystem =
    system: hostname:
    inputs.nixpkgs.lib.nixosSystem {
      inherit system;
      pkgs = mkPkgsWithSystem system;
      modules = [
        {
          nixpkgs.hostPlatform = system;
          _module.args = {
            inherit inputs system;
          };
        }
        inputs.home-manager.nixosModules.home-manager
        inputs.nix-index-database.nixosModules.nix-index
        inputs.nixos-wsl.nixosModules.default
        inputs.opnix.nixosModules.default
        {
          environment.pathsToLink = [
            "/share/applications"
            "/share/xdg-desktop-portal"
          ];

          home-manager = {
            inherit sharedModules;
            useUserPackages = true;
            useGlobalPkgs = true;
            extraSpecialArgs = {
              inherit inputs hostname system;
              isWSL = true;
            };
            users.stianrs = ../. + "/homes/stianrs";
          };
        }
        ../hosts/_modules/common
        ../hosts/_modules/nixos
        ../hosts/_modules/wsl
        ../hosts/${hostname}
      ];
      specialArgs = {
        inherit inputs hostname;
      };
    };
}
