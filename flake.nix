{
  description = "Rodent NixOS configuration";

  inputs = {
    # Nixpkgs and unstable
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    # Flake framework
    flake-parts.url = "github:hercules-ci/flake-parts";
    treefmt-nix.url = "github:numtide/treefmt-nix";

    # Home manager
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Catppuccin
    catppuccin = {
      url = "github:catppuccin/nix/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # nix-index-database
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    # NixOS-WSL
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    opnix.url = "github:brizzbuzz/opnix";
  };

  outputs =
    inputs@{ flake-parts, ... }:
    let
      mkPkgsWithSystem =
        system:
        import inputs.nixpkgs {
          inherit system;
          overlays = builtins.attrValues (import ./overlays { inherit inputs system; });
          config.allowUnfree = true;
        };
      mkSystemLib = import ./lib/mkSystem.nix { inherit inputs mkPkgsWithSystem; };
    in
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [ ./lib/treefmt.nix ];

      systems = [
        "x86_64-linux"
      ];

      perSystem =
        {
          system,
          pkgs,
          ...
        }:
        {
          # override pkgs used by everything in `perSystem` to have my overlays
          _module.args.pkgs = mkPkgsWithSystem system;
          # accessible via `nix build .#<name>`
          packages = import ./pkgs { inherit pkgs inputs; };
        };

      flake = {
        nixosConfigurations = {
          laptop = mkSystemLib.mkNixosSystem "x86_64-linux" "laptop";
          gamer = mkSystemLib.mkNixosSystem "x86_64-linux" "gamer";
          work = mkSystemLib.mkWslSystem "x86_64-linux" "work";
        };
      };
    };
}
