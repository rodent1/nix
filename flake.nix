{
  description = "Your new nix config";

  inputs = {
    # Nixpkgs and unstable
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    # Home manager
    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # nix-fast-build
    nix-fast-build = {
      url = "github:Mic92/nix-fast-build";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };

    # sops-nix
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # WSL
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-ld-rs = {
      url = "github:nix-community/nix-ld-rs";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    vscode-server = {
      url = "github:nix-community/nixos-vscode-server";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, ... }@inputs:
  let
    forAllSystems = nixpkgs.lib.genAttrs [
      "aarch64-linux"
      "x86_64-linux"
    ];
  in
  {
    hosts = import ./hosts.nix;
    lib = import ./lib inputs;

    pkgs = forAllSystems (localSystem: import nixpkgs {
      inherit localSystem;
      overlays = [ self.overlays.default ];
      config = {
        allowUnfree = true;
        allowAliases = true;
      };
    });

    pkgs-unstable = forAllSystems (localSystem: import nixpkgs-unstable {
      inherit localSystem;
      overlays = [ self.overlays.default ];
      config = {
        allowUnfree = true;
        allowAliases = true;
      };
    });

    overlays = import ./lib/generateOverlays.nix inputs;
    packages = forAllSystems (import ./packages inputs);

    nixosConfigurations = import ./lib/generateNixosConfigurations.nix inputs;
  };
}
