# Plan 001: Convert The Flake To Dendritic Flake-Parts Modules

> **Executor instructions**: Follow this plan step by step. Run every
> verification command and confirm the expected result before moving to the
> next step. If anything in the "STOP conditions" section occurs, stop and
> report instead of improvising. When done, update this plan's status row in
> `plans/README.md` unless a reviewer says they maintain the index.
>
> **Drift check (run first)**: `git diff --stat 36a4001..HEAD -- flake.nix flake.lock lib overlays pkgs hosts homes modules README.md AGENTS.md`
> If any in-scope file changed since this plan was written, compare the
> "Current State" excerpts against the live code before proceeding. Stop if
> the host list, package list, module arguments, or output wiring no longer
> matches this plan.

## Status

- **Priority**: P1
- **Effort**: L
- **Risk**: HIGH
- **Depends on**: none
- **Category**: migration
- **Planned at**: commit `36a4001`, 2026-07-11

## Why This Matters

The flake already uses flake-parts, but its composition is centralized in
`flake.nix`, `lib/mkSystem.nix`, directory `default.nix` import chains, and a
separate overlay/package registry. Adding or moving a feature therefore often
requires editing unrelated aggregator files. The target architecture makes
every maintained Nix file under `modules/` an automatically imported
flake-parts module, lets lower-level NixOS and Home Manager modules merge as
typed deferred-module option values, and keeps `flake.nix` as a minimal input
and bootstrap declaration.

This is an architecture migration, not a configuration redesign. Preserve all
three hosts, all three exported packages, the current overlays, the existing
NixOS and Home Manager `modules.*` option trees, WSL behavior, and treefmt
behavior.

## Current State

`flake.nix:43-81` manually creates an overlaid package set, imports package and
overlay registries, imports treefmt, and declares every host:

```nix
outputs = inputs@{ flake-parts, ... }:
  let
    mkPkgsWithSystem = system: import inputs.nixpkgs {
      inherit system;
      overlays = builtins.attrValues (import ./overlays { inherit inputs system; });
      config.allowUnfree = true;
    };
    mkSystemLib = import ./lib/mkSystem.nix { inherit inputs mkPkgsWithSystem; };
  in
  flake-parts.lib.mkFlake { inherit inputs; } {
    imports = [ ./lib/treefmt.nix ];
    systems = [ "x86_64-linux" ];
    # ...
  };
```

`lib/mkSystem.nix:14-88` has separate `mkNixosSystem` and `mkWslSystem`
constructors. Both import the same external modules and pass `inputs`,
`hostname`, `system`, and `isWSL` through `specialArgs` or
`home-manager.extraSpecialArgs`; the WSL constructor additionally imports
NixOS-WSL and `hosts/_modules/wsl`.

`homes/stianrs/default.nix:12-15` selects host configuration by path and starts
the Home Manager import tree:

```nix
hostConfig = ./hosts + "/${hostname}.nix";
# ...
imports = [ ../_modules ] ++ lib.optional (builtins.pathExists hostConfig) hostConfig;
```

`overlays/default.nix` currently provides three overlays. `additions` exposes
custom packages, `unstable-packages` exposes `pkgs.unstable`, and
`nixpkgs-overlays` defines `pnpm_10_29_2 = final.pnpm_10`. The current
`builtins.attrValues` use effectively composes them in attribute-name order:
`additions`, `nixpkgs-overlays`, then `unstable-packages`. The target must make
this ordering explicit.

`pkgs/default.nix` exports exactly `flate`, `kubectl-kopiur`, and `wagoapp`.
Their recipes are ordinary `callPackage` functions and consume
`pkgs/_sources/generated.nix`, which is generated from `pkgs/nvfetcher.toml`.

Current evaluated outputs at commit `36a4001` are:

```text
nixosConfigurations: gamer laptop work
packages.x86_64-linux: flate kubectl-kopiur wagoapp
checks.x86_64-linux: treefmt
formatter.x86_64-linux: treefmt
```

The repository only supports `x86_64-linux`. `work` is the WSL host. All hosts
embed Home Manager for user `stianrs` with `useGlobalPkgs = true` and
`useUserPackages = true`.

The existing lower-level feature convention must remain intact during this
migration: NixOS and Home Manager features declare options under `modules.*`,
and host-specific modules enable them. Do not rename that lower-level option
tree to match the new top-level architecture.

## Target Architecture

The final root must have this shape:

```nix
{
  description = "Rodent NixOS configuration";

  inputs = {
    # Existing inputs remain, with import-tree added.
  };

  outputs =
    inputs@{ flake-parts, import-tree, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [ (import-tree ./modules) ];
    };
}
```

Use `github:mightyiam/import-tree` as requested. Preserve existing input URLs
and `follows` relationships unless the user separately requests dependency
changes. In particular, do not copy stale release numbers from an example over
the live `26.05` inputs.

The final directory structure should be:

```text
flake.nix
modules/
  flake/
    core.nix
    model.nix
    hosts.nix
    nixpkgs.nix
    treefmt.nix
  home/
    ... automatically imported flake-parts modules ...
    _assets/
    _config/
  hosts/
    laptop.nix
    gamer.nix
    work.nix
    laptop/_hardware/default.nix
    gamer/_hardware/default.nix
    work/_hardware/default.nix
  nixos/
    ... automatically imported flake-parts modules ...
  overlays/
    unstable.nix
    aliases.nix
  packages/
    flate.nix
    kubectl-kopiur.nix
    wagoapp.nix
    nvfetcher.toml
    _recipes/
    _sources/
```

Names below `modules/home/` and `modules/nixos/` should retain recognizable
feature-oriented paths such as `shell/fish.nix`, `desktop/hyprland/*.nix`,
`services/podman.nix`, and `system/nh.nix`. Directory placement is for human
navigation only; no maintained flake-parts module may depend on an aggregator
`default.nix` or a path-derived import chain.

`modules/flake/model.nix` must declare typed top-level options in a private
namespace. Use these semantic roles; `rodent` is the recommended namespace:

```nix
options.rodent = {
  nixosModules = lib.mkOption {
    type = lib.types.lazyAttrsOf lib.types.deferredModule;
    default = { };
  };
  homeModules = lib.mkOption {
    type = lib.types.lazyAttrsOf lib.types.deferredModule;
    default = { };
  };
  hosts = lib.mkOption {
    type = lib.types.lazyAttrsOf (lib.types.submodule { /* system, isWSL */ });
    default = { };
  };
  packageRecipes = lib.mkOption {
    type = lib.types.lazyAttrsOf lib.types.path;
    default = { };
  };
  overlays = {
    aliases = lib.mkOption {
      type = lib.types.unspecified;
      default = final: prev: { };
    };
    unstable = lib.mkOption {
      type = lib.types.unspecified;
      default = final: prev: { };
    };
  };
};
```

`rodent.overlays.aliases` and `rodent.overlays.unstable` are uniquely owned
private overlay-function options. `modules/flake/nixpkgs.nix` constructs the
package-additions overlay from `rodent.packageRecipes`, composes those three
overlays in the required order, and uses the result internally. Do not export
`flake.overlays.default`; the current flake has no public overlay output and
output parity is a requirement.

Add `hostName` and `isWSL` options to the lower-level shared Home Manager
module, also under a private `rodent.*` namespace. Home Manager modules that
currently request `hostname` or `isWSL` as function arguments must read these
values from their Home Manager `config` instead. Do not use `specialArgs`,
`extraSpecialArgs`, `_module.args`, or `self` merely to pass top-level values
through lower-level evaluations.

Each maintained NixOS/Home Manager feature file must itself be a flake-parts
module. Its lower-level module is an option value, for example:

```nix
# modules/nixos/services/podman.nix
{
  rodent.nixosModules.default =
    { config, lib, pkgs, ... }:
    let
      cfg = config.modules.services.podman;
    in
    {
      # Existing options and config, unchanged in behavior.
    };
}
```

Shared files merge into `rodent.nixosModules.default` or
`rodent.homeModules.default`. Host-specific Home Manager fragments merge into
`rodent.homeModules.laptop`, `.gamer`, or `.work`. Host-specific NixOS content
merges into `rodent.nixosModules.<hostname>`. The WSL-only lower-level module
merges into `rodent.nixosModules.wsl`.

Nix files that are intentionally not flake-parts modules must live in a path
with an underscore-prefixed segment so `import-tree` ignores them. The allowed
exceptions are:

| Exception | Target path | Reason |
|-----------|-------------|--------|
| Generated hardware modules | `modules/hosts/<host>/_hardware/default.nix` | Generated NixOS modules are imported by their host module. |
| Package recipes | `modules/packages/_recipes/*.nix` | Native `callPackage` functions are simpler and idiomatic. |
| Nvfetcher output | `modules/packages/_sources/generated.nix` | Generated source data; never edit directly. |

Non-Nix assets such as the SSH public-key file, profile image, fish functions,
and Neovim configuration should move into clear `_assets` or `_config`
subtrees near their owning flake-parts module. Update references after moving.

## Commands You Will Need

| Purpose | Command | Expected on success |
|---------|---------|---------------------|
| Show outputs | `nix flake show --all-systems` | exit 0; only the expected host, package, formatter, and check outputs appear |
| Evaluate hosts | `nix eval --json .#nixosConfigurations --apply builtins.attrNames` | `["gamer","laptop","work"]` |
| Evaluate packages | `nix eval --json .#packages.x86_64-linux --apply builtins.attrNames` | `["flate","kubectl-kopiur","wagoapp"]` |
| Lightweight validation | `nix flake check --no-build` | exit 0 with no module evaluation errors |
| Full validation | `nix flake check` | exit 0 |
| Build laptop | `nix build .#nixosConfigurations.laptop.config.system.build.toplevel` | exit 0 |
| Build gamer | `nix build .#nixosConfigurations.gamer.config.system.build.toplevel` | exit 0 |
| Build work | `nix build .#nixosConfigurations.work.config.system.build.toplevel` | exit 0 |
| Build packages | `nix build .#flate .#kubectl-kopiur .#wagoapp` | exit 0 |
| Check formatting | `nix build .#checks.x86_64-linux.treefmt` | exit 0 |
| Compare closures | `nix store diff-closures /tmp/rodent-dendritic-baseline/<host> ./result-<host>` | no unexplained package/configuration differences |

## Scope

**In scope**:

- `flake.nix` and `flake.lock`
- All maintained Nix files and supporting assets currently under `lib/`, `overlays/`, `pkgs/`, `hosts/`, and `homes/`
- New files under `modules/flake/`, `modules/home/`, `modules/hosts/`, `modules/nixos/`, `modules/overlays/`, and `modules/packages/`
- `README.md` and `AGENTS.md`, which currently document the old wiring and contain stale package-output examples
- `plans/README.md` status only

**Out of scope**:

- Changing host behavior, package versions, input release branches, secret references, user identity, state versions, or hardware settings
- Renaming or removing the lower-level NixOS/Home Manager `modules.*` options
- Adding standalone `homeConfigurations`; Home Manager remains embedded in NixOS
- Adding systems other than `x86_64-linux`
- Introducing a second module-loader framework, flake generator, or custom general-purpose host library
- Editing generated nvfetcher source files except by moving them unchanged
- Regenerating hardware configuration

## Git Workflow

- Suggested branch: `refactor/dendritic-flake`
- Use logical commits for the bootstrap, NixOS migration, Home Manager migration, package/overlay migration, and cleanup when practical.
- Match the repository's conventional style, for example `refactor(flake): adopt dendritic module layout`.
- Do not push or open a pull request unless explicitly requested.
- Never use destructive checkout/reset commands to move files. Preserve concurrent user changes.

## Steps

### Step 1: Record A Behavioral Baseline

Before changing files, record the following command output in a temporary file
outside the repository or in the working notes: `nix flake show --all-systems`,
the two attribute-name evaluations from the command table, and these values for
each host:

```bash
nix eval --raw .#nixosConfigurations.laptop.config.networking.hostName
nix eval --raw .#nixosConfigurations.gamer.config.networking.hostName
nix eval --raw .#nixosConfigurations.work.config.networking.hostName
nix eval --json .#nixosConfigurations.work.config.wsl.enable
```

Also evaluate the package names and versions with
`nix eval --json .#packages.x86_64-linux --apply 'packages: builtins.mapAttrs (_: package: package.name) packages'`.
Evaluate and record representative overlay values:

```bash
nix eval --raw .#nixosConfigurations.laptop.config.nixpkgs.pkgs.pnpm_10_29_2.name
nix eval --raw .#nixosConfigurations.laptop.config.nixpkgs.pkgs.unstable.hyprland.name
```

Build durable baseline links outside the repository for closure comparison:

```bash
mkdir -p /tmp/rodent-dendritic-baseline
nix build .#nixosConfigurations.laptop.config.system.build.toplevel --out-link /tmp/rodent-dendritic-baseline/laptop
nix build .#nixosConfigurations.gamer.config.system.build.toplevel --out-link /tmp/rodent-dendritic-baseline/gamer
nix build .#nixosConfigurations.work.config.system.build.toplevel --out-link /tmp/rodent-dendritic-baseline/work
```

Do not put store paths or machine-local result symlinks into version control.

**Verify**: the host names are `laptop`, `gamer`, and `work`; WSL is `true` for
`work`; the host and package attribute lists match the Current State section.

### Step 2: Add Import-Tree And The Top-Level Model

Add the `import-tree` input and update only that lock entry plus unavoidable
transitive lock entries. Create `modules/flake/model.nix` with the typed options
described in Target Architecture. Create `modules/flake/core.nix` with
`systems = [ "x86_64-linux" ]`.

Create temporary compatibility modules under `modules/flake/` that assign the
old module trees to the new deferred-module values and reproduce the current
host metadata. This is a migration bridge only:

```nix
rodent.nixosModules.default.imports = [ ../../hosts/_modules/common ../../hosts/_modules/nixos ];
rodent.nixosModules.wsl = ../../hosts/_modules/wsl;
rodent.homeModules.default = ../../homes/stianrs;
rodent.nixosModules.laptop = ../../hosts/laptop;
rodent.nixosModules.gamer = ../../hosts/gamer;
rodent.nixosModules.work = ../../hosts/work;

rodent.hosts = {
  laptop = { system = "x86_64-linux"; isWSL = false; };
  gamer = { system = "x86_64-linux"; isWSL = false; };
  work = { system = "x86_64-linux"; isWSL = true; };
};
```

At this stage, keep the old special arguments in the new host evaluator because
the old lower-level files still require them. Mark the adapter clearly for
removal in Step 8; do not preserve it as a permanent compatibility layer.

Also add a temporary per-system package adapter equivalent to the current
`perSystem.packages = import ./pkgs { inherit pkgs inputs; };`. This adapter is
required before the root switch in Step 3 so all three package outputs remain
available. Remove it only after the package flake-parts modules export all three
packages in Step 7.

**Verify**: `nix flake lock --update-input import-tree` exits 0, and
`nix flake metadata --json` includes an `import-tree` lock node. Do not switch
the root `flake.nix` yet.

### Step 3: Add The Host Evaluator And Switch The Entry Point

Create `modules/flake/hosts.nix`. Map `config.rodent.hosts` to
`flake.nixosConfigurations` through one constructor and use `withSystem` to
obtain the same overlaid `pkgs` used by per-system outputs. The constructor must:

1. Import Catppuccin, Home Manager, nix-index-database, and opnix NixOS modules for every host.
2. Import NixOS-WSL and `config.rodent.nixosModules.wsl` only when `isWSL` is true.
3. Import `config.rodent.nixosModules.default` and `config.rodent.nixosModules.${hostname}`.
4. Set `nixpkgs.hostPlatform`, `networking.hostName`, and the temporary compatibility arguments.
5. Configure embedded Home Manager with the current shared external modules, global/user packages, and user `stianrs`.
6. Import both shared and host-specific Home Manager deferred modules; use `lib.attrByPath` or a declared empty default so a missing host-specific module has a predictable empty value.

Move treefmt configuration into `modules/flake/treefmt.nix`, importing
`inputs.treefmt-nix.flakeModule` there. Initially preserve old excludes and add
future excludes for `**/_hardware/**` and `modules/packages/_sources/*`.

Move the overlaid package-set construction into `modules/flake/nixpkgs.nix`.
Until package and overlay modules are migrated, it may reference the old
overlay registry. Set `perSystem._module.args.pkgs` exactly once so packages,
checks, and `withSystem` hosts all receive the same package set.

Replace `flake.nix` outputs with the minimal `mkFlake` plus
`imports = [ (import-tree ./modules) ]` form. Keep the full existing input set
and add `import-tree`; do not move input declarations out of `flake.nix`.

**Verify**: run `nix flake check --no-build`, both attribute-name evaluations,
all four host baseline evaluations from Step 1, and `nix flake show --all-systems`.
All must match the baseline.

### Step 4: Convert NixOS Modules Into Flake-Parts Modules

Move the maintained lower-level NixOS files from `hosts/_modules/` into
feature-oriented paths under `modules/nixos/`. Convert each file from a raw
NixOS module into a flake-parts module that contributes its original body to a
deferred-module value. Use `rodent.nixosModules.default` for common and normal
NixOS behavior and `rodent.nixosModules.wsl` for WSL-only behavior.

Eliminate old directory aggregators instead of recreating them. Specifically,
the old import-only files under `hosts/_modules/common/default.nix`,
`hosts/_modules/nixos/default.nix`, `services/default.nix`, `system/default.nix`,
and `users/default.nix` must either contribute their own real configuration as
flake-parts modules or disappear after their children are auto-imported.

For `hosts/_modules/common/nix.nix`, capture top-level `inputs` in the outer
flake-parts module and use it directly in the lower-level deferred module. This
removes the need for a NixOS `specialArgs.inputs` pass-through.

When recreating `nix.registry`, exclude the new framework-only `import-tree`
input so adopting the loader does not add a user-visible registry entry or
change every host closure for a bootstrap implementation detail. Preserve all
previously registered inputs.

Keep all existing option declarations and effective defaults unchanged,
including Podman and OpenSSH defaults, user/group construction, desktop
settings, state version, locale, shell, Nix, nh, opnix, 1Password, and SSH
settings.

Remove each old file only after its replacement is active, then remove the
temporary old NixOS-tree assignments from the compatibility module.

Perform each feature-group conversion atomically: add the new flake-parts
module, remove the corresponding import edge from the old aggregator, and
remove the old file before evaluating. Never let old and new copies of the same
lower-level definition participate simultaneously, because list options may be
duplicated even when scalar definitions happen to merge.

**Verify**: after each feature group, run `nix flake check --no-build`. After
all NixOS modules are converted, evaluate all three host names and WSL enablement
again; results must match Step 1.

### Step 5: Convert Home Manager Modules Into Flake-Parts Modules

Move every maintained Home Manager Nix file under `homes/` into
`modules/home/` and wrap its original lower-level module body as a contribution
to `rodent.homeModules.default` or a host-specific deferred module. This
includes the user defaults, themes, Kubernetes, desktop applications, Plasma,
Hyprland, security, shell tools, development tools, host desktop fragments,
and all per-host Hyprland fragments.

Do not preserve import-only `default.nix` aggregators. Auto-import supplies the
flake-parts modules; deferred-module merging supplies the lower-level module.
When a former parent and child both contain real behavior, each becomes its own
flake-parts module and both merge into the same deferred-module value.

Replace dynamic path imports based on `hostname` with host-specific merges:

| Old role | New deferred-module target |
|----------|----------------------------|
| `homes/stianrs/hosts/laptop.nix` and laptop desktop/Hyprland fragments | `rodent.homeModules.laptop` |
| `homes/stianrs/hosts/gamer.nix` and gamer desktop/Hyprland fragments | `rodent.homeModules.gamer` |
| `homes/stianrs/hosts/work.nix` | `rodent.homeModules.work` |
| All shared user and feature behavior | `rodent.homeModules.default` |

Declare lower-level `rodent.hostName` and `rodent.isWSL` Home Manager options
in the shared module. Set them from the host evaluator. Adapt these current
argument consumers to read Home Manager config instead:

- The former `homes/stianrs/default.nix`
- Desktop base
- Hyprland base
- opnix Home Manager configuration
- 1Password Home Manager configuration
- WSL2 SSH agent configuration

Preserve every existing `lib.mkIf` condition. Do not import desktop or
Hyprland host fragments on WSL; they may be present in the merged module but
their configuration must remain guarded by `!config.rodent.isWSL`.

Move supporting non-Nix content without changing it. Suggested destinations
are `modules/home/_assets/ssh/ssh.pub`,
`modules/home/desktop/_assets/profile.jpg`,
`modules/home/shell/fish/_config/functions/`, and
`modules/home/shell/nvim/_config/`. Update every source/readFile reference.

Remove each old Home Manager file after its replacement participates in the
evaluation. Remove the old Home Manager compatibility assignment after all
features and host fragments have moved.

As with NixOS, migrate each Home Manager feature group atomically. Remove its
old parent import edge and old file in the same change that activates the new
flake-parts module. Do not evaluate with both copies active, and do not leave an
old aggregator importing a path that has already moved.

**Verify**: run `nix flake check --no-build` after each major feature group.
Then run all three exact host builds. All must exit 0.

### Step 6: Convert Host Declarations And Hardware Exceptions

For each host, create one automatically imported flake-parts module under
`modules/hosts/<hostname>.nix`. It must declare host metadata in
`rodent.hosts.<hostname>` and contribute the old host body to
`rodent.nixosModules.<hostname>`.

Move each generated `hardware-configuration.nix` unchanged to
`modules/hosts/<hostname>/_hardware/default.nix`. Import it only from that
host's deferred NixOS module. The `_hardware` segment is required so
`import-tree` does not evaluate a generated NixOS module as flake-parts.

Preserve laptop graphics/Bluetooth/fingerprint settings, gamer NVIDIA/Steam
settings, work's WSL status, and all desktop feature selections. Once all three
hosts use the new declarations, remove `hosts/laptop`, `hosts/gamer`,
`hosts/work`, and the host portion of the temporary compatibility module.

**Verify**: run both attribute-name evaluations, all Step 1 host-value
evaluations, and all three host builds. Results must match the baseline and all
builds must exit 0.

### Step 7: Convert Packages And Overlays

Move the recipes unchanged to `modules/packages/_recipes/{flate,kubectl-kopiur,wagoapp}.nix`.
Move `pkgs/_sources/` unchanged to `modules/packages/_sources/` and update the
three recipe references. Move `pkgs/nvfetcher.toml` to
`modules/packages/nvfetcher.toml`; this remains the source of truth for source
updates.

Create one automatically imported flake-parts module per package. Each module
registers its recipe path in `rodent.packageRecipes.<name>` and exports the
overlay-provided package through `perSystem.packages.<name> = pkgs.<name>`.

In `modules/flake/nixpkgs.nix`, build the additions overlay by mapping
`config.rodent.packageRecipes` to `final.callPackage recipe { }`. In
`modules/overlays/`, convert the unstable package set and stable alias into
flake-parts modules that set `rodent.overlays.unstable` and
`rodent.overlays.aliases`, respectively. Compose one private overlay stack in
`modules/flake/nixpkgs.nix` in an explicit order equivalent to current
behavior: additions, stable aliases, unstable packages. Use that stack in the
per-system stable package-set import. Continue setting
`config.allowUnfree = true` for stable and unstable package sets. Preserve the
current behavior in which `pkgs.unstable` is a separate nixpkgs-unstable import
without recursively applying the stable overlay stack.

Do not export a new `overlays` flake output. Do not make package exports call
recipes separately from the overlay, because hosts and flake packages must
resolve to the same derivations. Remove the temporary package adapter from Step
2 only after all three new exports evaluate.

Delete old `pkgs/` and `overlays/` only after package evaluation and builds
pass.

**Verify**: run the package attribute-name evaluation, evaluate package names
against the Step 1 baseline, run `nix build .#flate .#kubectl-kopiur .#wagoapp`,
and run `nix flake check --no-build`. For each package, compare its exported
`drvPath` with the same package from a host package set; for example:

```bash
test "$(nix eval --raw .#flate.drvPath)" = "$(nix eval --raw .#nixosConfigurations.laptop.config.nixpkgs.pkgs.flate.drvPath)"
test "$(nix eval --raw .#kubectl-kopiur.drvPath)" = "$(nix eval --raw .#nixosConfigurations.laptop.config.nixpkgs.pkgs.kubectl-kopiur.drvPath)"
test "$(nix eval --raw .#wagoapp.drvPath)" = "$(nix eval --raw .#nixosConfigurations.laptop.config.nixpkgs.pkgs.wagoapp.drvPath)"
```

All commands must pass. Re-evaluate the representative alias and unstable
package names from Step 1 and confirm they are unchanged.

### Step 8: Remove Compatibility Plumbing And Dead Files

Remove all temporary old-tree adapters. Remove `specialArgs`,
`home-manager.extraSpecialArgs`, and custom `_module.args` used only for
`inputs`, `hostname`, `system`, or `isWSL`. Keep only flake-parts' normal
`perSystem._module.args.pkgs` override required to make per-system evaluation
use the overlaid package set.

Delete `lib/mkSystem.nix`, `lib/treefmt.nix`, and any now-empty `lib/`,
`hosts/`, `homes/`, `overlays/`, or `pkgs/` directories. Search all maintained
Nix files under `modules/`; every `.nix` file outside an underscore-prefixed
path must have flake-parts top-level shape and must not be manually imported by
path from another repository module.

Literal imports remain valid only for external flake modules, generated
hardware modules, and package recipes/source data. Do not add a replacement
chain of `default.nix` aggregators.

**Verify**: `git grep -nE 'specialArgs|extraSpecialArgs|lib/mkSystem|lib/treefmt|\.\./\.\./(hosts|homes|pkgs|overlays)' -- '*.nix'` returns no matches. Review any `_module.args` match and confirm only the per-system `pkgs` override remains.

### Step 9: Update Documentation

Update `README.md` structure documentation to describe `flake.nix`,
`modules/flake`, `modules/home`, `modules/hosts`, `modules/nixos`,
`modules/overlays`, and `modules/packages`. Explain that all maintained Nix
files under `modules/` are flake-parts modules and underscore-prefixed paths
contain explicit exceptions ignored by `import-tree`.

Update `AGENTS.md` to reflect the new entry points and exact outputs. Correct
the stale package references there: the live package set is `flate`,
`kubectl-kopiur`, and `wagoapp`, not `faugus-launcher`. Update nvfetcher's
working-directory command to the new package directory.

**Verify**: `git grep -nE 'lib/mkSystem|homes/_modules|hosts/_modules|pkgs/default|overlays/default|faugus-launcher' README.md AGENTS.md` returns no matches.

### Step 10: Run Full Verification

Run every command in Commands You Will Need. Compare `nix flake show` and all
baseline evaluations with Step 1. Inspect `git status --short` and confirm that
all deletions have replacements under `modules/`, generated files were only
moved, and no unrelated files changed.

Build final host outputs with explicit non-default links and compare their
closures to the Step 1 baseline:

```bash
nix build .#nixosConfigurations.laptop.config.system.build.toplevel --out-link result-laptop
nix build .#nixosConfigurations.gamer.config.system.build.toplevel --out-link result-gamer
nix build .#nixosConfigurations.work.config.system.build.toplevel --out-link result-work
nix store diff-closures /tmp/rodent-dendritic-baseline/laptop ./result-laptop
nix store diff-closures /tmp/rodent-dendritic-baseline/gamer ./result-gamer
nix store diff-closures /tmp/rodent-dendritic-baseline/work ./result-work
```

Inspect every closure difference. Moved Home Manager source directories may
produce content-equivalent store paths with different source names; those are
acceptable only when traced directly to an asset/config path move and the
consuming Home Manager option is unchanged. Package additions/removals, service
changes, a new `import-tree` registry entry, or unexplained configuration paths
are not acceptable. Restore parity for those differences. Remove the three
repository-local result links after comparison.

If host builds are too expensive to run concurrently, run them sequentially.
Do not substitute `nix flake check --no-build` for the three exact host builds;
CI builds those outputs and lower-level module mistakes often appear only while
realizing the system closure.

**Verify**: all commands exit 0; output attribute names and baseline values are
unchanged; the old architecture directories contain no remaining source files.

## Test Plan

No separate unit-test framework exists for this Nix configuration. Evaluation
and exact derivation builds are the regression suite.

- Validate auto-import and top-level option wiring with `nix flake check --no-build`.
- Validate public output compatibility with `nix flake show --all-systems` and exact attribute-name evaluations.
- Validate lower-level NixOS/Home Manager composition by building `laptop`, `gamer`, and `work` system closures.
- Validate WSL branching by evaluating `nixosConfigurations.work.config.wsl.enable` as `true`.
- Validate package registry, overlay exposure, and recipes by evaluating and building all three packages.
- Validate that package outputs and host package sets share identical derivations with the three `drvPath` equality checks from Step 7.
- Validate formatter migration by building `checks.x86_64-linux.treefmt`.
- Validate import-tree boundaries by confirming all intentionally raw `.nix` files are under `_hardware`, `_recipes`, or `_sources`.
- Validate broad behavioral parity with pre/post `nix store diff-closures` comparisons for all three systems.

## Done Criteria

- [ ] Root `flake.nix` contains inputs plus the minimal flake-parts/import-tree bootstrap and no host/package/overlay construction.
- [ ] `import-tree` is locked from `github:mightyiam/import-tree`.
- [ ] Every maintained `.nix` file under `modules/` is an automatically imported flake-parts module unless its path contains `_hardware`, `_recipes`, or `_sources`.
- [ ] `nixosConfigurations` contains exactly `gamer`, `laptop`, and `work`.
- [ ] `packages.x86_64-linux` contains exactly `flate`, `kubectl-kopiur`, and `wagoapp`.
- [ ] `work` still evaluates with WSL enabled; all host names match their output names.
- [ ] No `specialArgs` or `extraSpecialArgs` pass-through remains.
- [ ] Stable package sets, NixOS hosts, Home Manager, and flake package outputs use the same explicitly composed overlay policy; `pkgs.unstable` remains the current separate allow-unfree import.
- [ ] Existing lower-level `modules.*` options and host feature selections remain behaviorally unchanged.
- [ ] Every pre/post closure difference for `laptop`, `gamer`, and `work` is accounted for solely by content-equivalent moved Home Manager source paths; no package, service, registry, or unexplained configuration difference remains.
- [ ] `nix flake check`, all three host builds, all three package builds, and the treefmt check exit 0.
- [ ] `README.md` and `AGENTS.md` document the new architecture and exact current outputs.
- [ ] Old `lib/`, `hosts/`, `homes/`, `overlays/`, and `pkgs/` source trees are removed after migration.
- [ ] `plans/README.md` marks Plan 001 DONE.

## STOP Conditions

Stop and report instead of improvising if:

- The drift check shows the host list, package list, or central wiring changed after commit `36a4001`.
- Current `import-tree` behavior does not ignore every path containing an underscore-prefixed segment as documented upstream.
- `lib.types.deferredModule` is unavailable in the pinned flake-parts/Nixpkgs library or repeated definitions do not merge as expected. Report the exact evaluation error before choosing a different model.
- Home Manager's embedded module cannot consume the merged deferred modules without reintroducing broad `extraSpecialArgs`.
- Preserving one package set for per-system outputs and NixOS hosts creates an evaluation cycle through `withSystem`.
- A host or package output disappears or a new public output appears unexpectedly.
- Any migration step appears to require changing a secret reference, generated hardware content, package version, state version, or host behavior.
- An exact host build fails twice after correcting straightforward path/module-shape errors.
- Concurrent user changes directly conflict with a file being moved.

## Maintenance Notes

- New maintained Nix files under `modules/` are imported automatically. They must be flake-parts modules; place unavoidable raw Nix expressions below an underscore-prefixed path.
- Add reusable NixOS behavior by merging into `rodent.nixosModules.default`, WSL-only behavior into `.wsl`, and host-only behavior into `.<hostname>`.
- Add reusable Home Manager behavior by merging into `rodent.homeModules.default` and host-only behavior into `.<hostname>`.
- Add a package by creating an ignored recipe, registering it through an auto-imported package flake-parts module, and exporting `pkgs.<name>` through `perSystem.packages`.
- Reviewers should focus on accidental behavior changes caused by lost former import edges, WSL guards, host-specific Home Manager fragments, asset path moves, and overlay ordering.
- A later cleanup may reconsider the numerous lower-level `modules.*.enable` options in light of the dendritic recommendation that importing a feature usually enables it. That is intentionally deferred until this migration has proven output parity.
