![Banner](logo.png)

### ❄️ My Nix Flake Repository 🚧

This repo contains my complete system configuration for a declarative, reproducible, and minimal NixOS setup — tailored for daily development, Kubernetes home-ops, WSL2 integration, and soothing Catppuccin-based fish shell theming.


## ✨ Features

- ❄️ **Nix flakes**: Modular, composable, version-locked
- 🐟 **Fish shell**: Minimal `fish` shell setup with soothing `Catppuccin` colours and a `Starship` prompt.
- 🔐 **Secrets management**: Secrets encrypted and managed with `opnix`
- 🧰 **WSL2-friendly**: Tested extensively in Windows Subsystem for Linux
- 🧪 **Development modules**: Streamlined development environments for multiple languages and tools
- 🧩 **Custom packages**: Custom `nixpkgs` overlays and pkgs managed declaratively


## 🧩 Structure

```bash
.
├── flake.nix             # Inputs and the flake-parts/import-tree bootstrap
├── flake.lock            # Locked dependencies
└── modules/
    ├── flake/            # Top-level model, hosts, nixpkgs, and treefmt
    ├── home/             # Home Manager features and host fragments
    ├── hosts/            # Host metadata and host-specific NixOS modules
    ├── nixos/            # Shared NixOS features
    ├── overlays/         # Private package-set overlays
    └── packages/         # Package registrations, recipes, and sources

```

Every maintained Nix file under `modules/` is automatically imported as a
flake-parts module. Paths with an underscore-prefixed segment are ignored by
`import-tree`; they contain explicit raw exceptions such as generated hardware
modules, package recipes and sources, or supporting assets and configuration.

## 📚 References

Built on the shoulders of those who came before me

- [bjw-s nix-config](https://github.com/bjw-s/nix-config)
- [billimek dotfiles](https://github.com/billimek/dotfiles)
- [Misterio77/nix-starter-config](https://github.com/Misterio77/nix-starter-configs)


## 🧊 Powered by

Built with love, flakes and frustration. ♥
