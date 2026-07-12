![Banner](logo.png)

# ❄️ My Nix Flake Repository 🚧

This repo contains my complete system configuration for a declarative, reproducible, and minimal NixOS setup — tailored for daily development, Kubernetes home-ops, WSL2 integration, and soothing Catppuccin-based fish shell theming.


## ✨ Features

- ❄️ **Nix flakes**: Modular, composable, version-locked
- 🐟 **Fish shell**: Minimal `fish` shell setup with soothing `Catppuccin` colours and a `Starship` prompt.
- 🔐 **Secrets management**: Secrets encrypted and managed with `opnix`
- 🧰 **WSL2-friendly**: Tested extensively in Windows Subsystem for Linux
- 🧪 **Development modules**: Streamlined development environments for multiple languages and tools
- 🧩 **Custom packages**: Custom `nixpkgs` overlays and pkgs managed declaratively


## 🧩 Structure

The repository uses a dendritic flake-parts layout, with configuration grouped
by purpose under `modules/`.

```text
.
├── flake.nix             # Inputs and the flake-parts/import-tree bootstrap
├── flake.lock            # Locked dependencies
└── modules/
    ├── flake/            # Internal model, host assembly, nixpkgs, and treefmt
    ├── home/             # Reusable Home Manager features and host fragments
    ├── hosts/            # Host metadata, hardware, and host-specific NixOS modules
    ├── nixos/            # Shared NixOS features
    ├── overlays/         # Private package-set overlays
    ├── packages/         # Exported packages, recipes, and generated sources
    └── users/            # Per-user NixOS accounts and Home Manager defaults
```

`flake.nix` delegates composition to flake-parts. `import-tree` automatically
imports every maintained Nix file below `modules/` as a flake-parts module.
Paths containing an underscore-prefixed segment are excluded; these hold raw
NixOS modules, package recipes and sources, assets, or application config that
must be imported explicitly.

Modules merge into the private `internal` namespace. `modules/flake/hosts.nix`
turns that model into the public `nixosConfigurations.{laptop,gamer,work}`
outputs and embeds Home Manager for `stianrs`. The concrete account and personal
Home Manager defaults live under `modules/users/stianrs/`. Shared NixOS and Home
Manager modules apply to every host, while host-specific fragments are selected
by the output name. Desktop Home Manager modules are omitted from the WSL host.

The package overlay combines local recipes, stable aliases, and an unstable
package set. The resulting package set is shared by NixOS, Home Manager, and
the exported `packages.x86_64-linux` outputs.

## 🚀 Bootstrap

This repository contains hardware configuration for the physical `laptop` and
`gamer` hosts, plus the `work` NixOS-WSL host. Only deploy an output to its
matching machine; a new machine with different disks or hardware needs its own
host and generated hardware module first.

### Physical hosts: `laptop` or `gamer`

1. Install a minimal NixOS system from the ISO/USB installer and boot into it.
   Ensure the `stianrs` user exists and can use `sudo`.

2. Install Git temporarily and clone the repository at the path expected by
   `programs.nh.flake`:

   ```bash
   nix-shell -p git
   git clone https://github.com/rodent1/nix /home/stianrs/nix
   exit
   ```

3. Apply the matching host output. Replace `gamer` with `laptop` as
   appropriate:

   ```bash
   sudo nixos-rebuild switch \
     --flake /home/stianrs/nix#gamer \
     --option experimental-features "nix-command flakes"
   ```

   The first activation installs Home Manager, `nh`, and `opnix`. OpNix safely
   skips secret retrieval while its user token is absent.

4. Store the 1Password service-account token as the user. The `-path` option
   must appear before the `set` subcommand:

   ```bash
   mkdir -p ~/.config/opnix
   opnix token -path "$HOME/.config/opnix/token" set
   chmod 600 ~/.config/opnix/token
   ```

5. Activate once more to retrieve Home Manager secrets:

   ```bash
   nh os switch
   ```

### WSL host: `work`

Install NixOS-WSL using its documented distribution/import process first. Once
the WSL instance has a working Nix installation and the `stianrs` user, clone
this repository to `/home/stianrs/nix` and apply the WSL output:

```bash
nix-shell -p git
git clone https://github.com/rodent1/nix /home/stianrs/nix
exit

sudo nixos-rebuild switch \
  --flake /home/stianrs/nix#work \
  --option experimental-features "nix-command flakes"
```

Install the user-scoped OpNix token as described above, then run:

```bash
nh os switch
```

Subsequent rebuilds can use `nh os switch` while the repository remains at
`/home/stianrs/nix` and the checkout contains the intended branch or revision.

## 🛠️ Operator Quick Start

These commands require Nix with flakes enabled. This flake supports only
`x86_64-linux`, with the `gamer`, `laptop`, and `work` hosts and the `flate`,
`kubectl-kopiur`, and `wagoapp` packages.

Inspect all supported outputs:

```bash
nix flake show --all-systems
```

Evaluate the flake without building derivations for a lightweight check, or run
the full flake check when builds are appropriate:

```bash
nix flake check --no-build
nix flake check
```

Build the exact system closure for the host being changed, replacing `gamer`
with `laptop` or `work` when appropriate:

```bash
nix build .#nixosConfigurations.gamer.config.system.build.toplevel
```

Build an exported package by name, for example:

```bash
nix build .#flate
```

The complete exported package list is `flate`, `kubectl-kopiur`, and `wagoapp`.
On configured machines using this repository at `/home/stianrs/nix`, activate
the checkout with:

```bash
nh os switch
```

Unlike the inspection and build commands, activation changes the running
system. It is for machines already configured from this checkout, not for a
fresh installation. See [AGENTS.md](AGENTS.md) for contributor-oriented module,
package, and CI verification guidance.

## 📚 References

Built on the shoulders of those who came before me

- [bjw-s nix-config](https://github.com/bjw-s/nix-config)
- [billimek dotfiles](https://github.com/billimek/dotfiles)
- [Misterio77/nix-starter-config](https://github.com/Misterio77/nix-starter-configs)


## 🧊 Powered by

Built with love, flakes and frustration. ♥
