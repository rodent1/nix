{
  description = "Rodent NixOS configuration";

  inputs = {
    # Nixpkgs and unstable
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    # Flake-parts - Simplify Nix Flakes with the module system
    # https://github.com/hercules-ci/flake-parts
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
    };

    # Home manager
    # https://github.com/nix-community/home-manager
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Catppuccin
    # https://github.com/catppuccin/nix
    catppuccin = {
      url = "github:catppuccin/nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Krewfile
    # https://github.com/brumhard/krewfile
    krewfile = {
      url = "github:brumhard/krewfile";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # nix-darwin
    # https://github.com/LnL7/nix-darwin
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # nix-index-database
    # https://github.com/nix-community/nix-index-database"
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    # WSL
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # nvf
    #
    nvf = {
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
      inputs.flake-parts.follows = "flake-parts";
    };

    # Rust toolchain overlay
    # https://github.com/oxalica/rust-overlay
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    # sops-nix
    # https://github.com/Mic92/sops-nix
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Talhelper
    # https://github.com/budimanjojo/talhelper
    talhelper = {
      url = "github:budimanjojo/talhelper";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
    };
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
      imports = [ ];

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
          laptop = mkSystemLib.mkWslSystem "x86_64-linux" "laptop";
          gamer = mkSystemLib.mkWslSystem "x86_64-linux" "gamer";
          work = mkSystemLib.mkWslSystem "x86_64-linux" "work";
        };
      };
    };
}
