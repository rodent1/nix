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
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    # Home manager
    # https://github.com/nix-community/home-manager
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Catppuccin
    # https://github.com/catppuccin/nix
    catppuccin = {
      url = "github:catppuccin/nix";
    };

    # JeezyVim
    # https://github.com/LGUG2Z/JeezyVim
    jeezyvim = {
      url = "github:LGUG2Z/JeezyVim";
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

    # WSL
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Rust toolchain overlay
    # https://github.com/oxalica/rust-overlay
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
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
    };
  };

  outputs =
    { flake-parts, ... }@inputs:
    let
      mkSystemLib = import ./lib/mkSystem.nix { inherit inputs; };
    in
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-darwin"
      ];

      flake = {
        nixosConfigurations = {
          laptop = mkSystemLib.mkWslSystem "x86_64-linux" "laptop";
          gamer = mkSystemLib.mkWslSystem "x86_64-linux" "gamer";
          work = mkSystemLib.mkWslSystem "x86_64-linux" "work";
        };
      };
    };
}
