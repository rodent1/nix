{ inputs, overlays, ... }:
{
  mkNixosSystem =
    system: hostname:
    inputs.nixpkgs.lib.nixosSystem {
      inherit system;
      pkgs = import inputs.nixpkgs {
        inherit system;
        overlays = builtins.attrValues overlays;
        config = {
          allowUnfree = true;
          allowUnfreePredicate = _: true;
        };
      };
      modules = [
        {
          nixpkgs.hostPlatform = system;
          _module.args = {
            inherit inputs system;
          };
        }
        inputs.sops-nix.nixosModules.sops
        inputs.home-manager.nixosModules.home-manager
        {
          home-manager = {
            useUserPackages = true;
            useGlobalPkgs = true;
            sharedModules = [
              inputs.krewfile.homeManagerModules.krewfile
              inputs.nix-index-database.hmModules.nix-index
              inputs.catppuccin.homeManagerModules.catppuccin
              inputs.sops-nix.homeManagerModules.sops
            ];
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
      pkgs = import inputs.nixpkgs {
        inherit system;
        overlays = builtins.attrValues overlays;
        config = {
          allowUnfree = true;
          allowUnfreePredicate = _: true;
        };
      };
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
            useUserPackages = true;
            useGlobalPkgs = true;
            sharedModules = [
              inputs.krewfile.homeManagerModules.krewfile
              inputs.nix-index-database.hmModules.nix-index
              inputs.catppuccin.homeManagerModules.catppuccin
              inputs.sops-nix.homeManagerModules.sops
            ];
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
      pkgs = import inputs.nixpkgs {
        inherit system;
        overlays = builtins.attrValues overlays;
        config = {
          allowUnfree = true;
          allowUnfreePredicate = _: true;
        };
      };
      modules = [
        {
          nixpkgs.hostPlatform = system;
          _module.args = {
            inherit inputs system;
          };
        }
        inputs.home-manager.darwinModules.home-manager
        {
          home-manager = {
            useUserPackages = true;
            useGlobalPkgs = true;
            sharedModules = [
              inputs.krewfile.homeManagerModules.krewfile
              inputs.nix-index-database.hmModules.nix-index
              inputs.catppuccin.homeManagerModules.catppuccin
              inputs.sops-nix.homeManagerModules.sops
            ];
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
