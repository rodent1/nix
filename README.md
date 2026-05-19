# ❄️ Rodent's NixOS Configuration
![Banner](logo.png)

### Repository structure
Everything under `./modules/` is a flake-parts module and is automatically imported using [vic/import-tree](https://github.com/vic/import-tree).
```
├── flake.nix       # Entry-point of the flake
└── modules/
    ├── flake/      # flake modules
    ├── home/       # shared home-manager modules
    ├── hosts/      # declaration of the NixOS/HM hosts
    ├── nixos/      # shared nixos modules
    ├── overlays/   # nixpkgs overlays
    └── packages/   # custom packages
```