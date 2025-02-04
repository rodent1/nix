{
  inputs,
  mkPkgsWithSystem,
  ...
}:
let
  sharedModules = [
    inputs.catppuccin.homeManagerModules.catppuccin
    inputs.krewfile.homeManagerModules.krewfile
    inputs.nix-index-database.hmModules.nix-index
    inputs.sops-nix.homeManagerModules.sops
    inputs.nvf.homeManagerModules.default
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
        {
          home-manager = {
            inherit sharedModules;
            useUserPackages = true;
            useGlobalPkgs = true;
            extraSpecialArgs = {
              inherit inputs hostname system;
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
        inputs.nixos-wsl.nixosModules.default
        {
          home-manager = {
            inherit sharedModules;
            useUserPackages = true;
            useGlobalPkgs = true;
            extraSpecialArgs = {
              inherit inputs hostname system;
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

  mkDarwinSystem =
    system: hostname:
    inputs.nix-darwin.lib.darwinSystem {
      inherit system;
      pkgs = mkPkgsWithSystem system;
      modules = [
        {
          nixpkgs.hostPlatform = system;
          _module.args = {
            inherit inputs;
          };
        }
        inputs.home-manager.darwinModules.home-manager
        {
          home-manager = {
            inherit sharedModules;
            useUserPackages = true;
            useGlobalPkgs = true;
            extraSpecialArgs = {
              inherit inputs hostname system;
            };
            users.stianrs = ../. + "/homes/stianrs";
          };
        }
        ../hosts/_modules/common
        ../hosts/_modules/darwin
        ../hosts/${hostname}
      ];
      specialArgs = {
        inherit inputs hostname;
      };
    };
}
