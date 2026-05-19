# AGENTS.md

Nix flake managing NixOS hosts, Nixos-WSL hosts, and Home Manager user configurations.

## Architecture
- **Pattern**: dendritic flake-parts via [`mightyiam/import-tree`](https://github.com/mightyiam/import-tree). `flake.nix` is `mkFlake` + `(import-tree ./modules)` — every `.nix` file under `./modules/` is a flake-parts module loaded recursively, and outputs are produced by option-merging.
- **Formatter**: `treefmt-nix` (run `nix fmt`).
- **Key inputs**: `nixpkgs`, `nixpkgs-unstable`, `home-manager`, `nixos-wsl`, `flake-parts`, `import-tree`, `opnix`.

## Directory layout
| Path | Purpose |
|---|---|
| `modules/flake/hosts.nix` | Central host registry (`mkNixos` / `mkWsl` / `mkHome` helpers + every host listed explicitly) |
| `modules/flake/treefmt.nix` | `perSystem.formatter` |
| `modules/nixos/<name>.nix` | Reusable NixOS feature modules (exported via `flake.nixosModules.<name>`) |
| `modules/home/<name>.nix` | Reusable Home Manager feature modules (exported via `flake.homeManagerModules.<name>`) |
| `modules/overlays/<name>.nix` | One flake-parts module per overlay (`flake.overlays.<name>`) |
| `modules/packages/<name>.nix` | Registers a `perSystem.packages.<name>` from `packages/<name>.nix` |
| `hosts/nixos/<host>/` | NixOS host configs (`gamer`, `laptop`) — NOT loaded by import-tree |
| `hosts/wsl/<host>.nix` | nixos-wsl host configs (`work`) |
| `packages/<name>.nix` | Raw callPackage-style derivations |

## Module pattern
Feature modules retain the NixOS-style shape but are wrapped in a flake-parts module that registers them under `flake.<class>Modules.<name>`:

```nix
# modules/nixos-modules/<name>.nix
{ ... }:
{
  flake.nixosModules.<name> = { config, lib, pkgs, ... }:
    let cfg = config.modules.<name>;
    in {
      imports = [ ... ];  # MUST be top-level — never inside mkIf
      options.modules.<name>.enable = lib.mkEnableOption "<description>";
      config = lib.mkIf cfg.enable { ... };
    };
}
```

## Adding things

1. **New feature module**: drop `modules/{nixos,home}/<name>.nix` wrapped in `{ ... }: { flake.<class>Modules.<name> = <NixOS module>; }`. `import-tree` picks it up; nothing else to wire.
2. **New host**: TODO
3. **New overlay**: drop `modules/overlays/<name>.nix` exporting `flake.overlays.<name> = final: prev: { ... }`.
4. **New package**: place the callPackage derivation at `packages/<name>.nix` and register it via `modules/packages/<name>.nix`:
   ```nix
   { ... }:
   {
     perSystem = { pkgs, ... }: {
       packages.<name> = pkgs.callPackage ../../packages/<name>.nix { };
     };
   }
   ```
5. **NixOS users**: `modules/nixos-modules/users/<user>.nix` is one self-contained module per user. Enable on a host via `modules.users.<user>.enable = true;`.

## `pkgs-unstable` availability
`pkgs-unstable` is injected via `specialArgs` for **Darwin and Home Manager only** (`modules/wiring/hosts.nix`). In **NixOS modules**, use `pkgs.unstable.*` instead (provided by the `unstable-packages` overlay at `modules/overlays/unstable-packages.nix`).

## Secrets
- **opnix** (1Password) — runtime secrets on NixOS hosts via `services.onepassword-secrets`. Configured in `modules/nixos-modules/opnix.nix`.
- Never commit plaintext secrets.

## Conventions
- Drop new module files into the appropriate `modules/.../*.nix` location; `import-tree` picks them up automatically.
- Keep edits minimal and consistent with nearby patterns.
- Commit messages use `scope: description` format. Common scopes: `flake`, `home`, `darwin`, `nixos`, `nas`, `cloud`, `docs`. Multi-scope example: `flake,home,darwin: ...`.

## Verify before committing
```
nix fmt          # format all .nix files
nix flake check  # catch eval errors (needs git-crypt unlocked if work-laptop is in scope)
```

## Rebuild commands
- NixOS: `nh os switch .` or `sudo nixos-rebuild switch --flake .#<host>`
- Home Manager: `nh home switch .` or `home-manager switch --flake .#<user@host>`