# Plan 009: Co-locate and simplify the stianrs user configuration

> **Executor instructions**: Follow this plan step by step. Run every
> verification command and confirm the expected result before moving to the
> next step. If anything in the "STOP conditions" section occurs, stop and
> report; do not improvise. When done, update this plan's status row in
> `plans/README.md` unless a reviewer dispatched you and said they maintain the
> index.
>
> **Drift check (run first)**:
> `git diff --stat 796f163..HEAD -- modules/flake/hosts.nix modules/nixos/users modules/home/user.nix modules/users`
> If an in-scope file changed since this plan was written, compare the current
> state excerpts below with the live code before proceeding. If behavior or
> ownership has changed, treat that as a STOP condition.

## Status

- **Priority**: P2
- **Effort**: S
- **Risk**: MED
- **Depends on**: Plan 001 (DONE)
- **Category**: tech-debt
- **Planned at**: commit `796f163`, 2026-07-12

## Why this matters

The only system user is currently spread across a generic user model, a
NixOS-specific user module, a personal Home Manager module, and hardcoded host
assembly. The generic options are not consumed anywhere, so they obscure the
actual configuration without enabling reuse. Co-locating the concrete NixOS and
Home Manager definitions under `modules/users/stianrs/` makes the user boundary
discoverable while retaining only the small amount of explicit host glue that
embedded Home Manager requires.

## Current state

- `modules/nixos/users/model.nix` defines `modules.users.groups` and
  `modules.users.additionalUsers`, maps them into `config.users`, and sets
  `users.mutableUsers = true`. No module assigns either custom option.
- `modules/nixos/users/stianrs.nix` defines the actual account and two more
  unused extension options, `modules.users.stianrs.extraGroups` and
  `modules.users.stianrs.packages`.
- `modules/home/user.nix` defines the Home Manager `host` options and the
  personal shell, Git, SSH, and theme selections.
- `modules/flake/hosts.nix` embeds Home Manager and currently imports shared,
  host-specific, and desktop modules directly into `users.stianrs`.
- Every maintained `.nix` file under `modules/` is automatically imported as a
  flake-parts module. New files under `modules/users/stianrs/` therefore need to
  assign deferred modules through `internal.nixosModules` or
  `internal.homeModules`; they must not be raw NixOS/Home Manager modules.

Current generic model at `modules/nixos/users/model.nix:8-23`:

```nix
options.modules.users = {
  groups = lib.mkOption {
    type = lib.types.attrs;
    default = { };
  };
  additionalUsers = lib.mkOption {
    type = lib.types.attrs;
    default = { };
  };
};

config.users = {
  inherit (cfg) groups;
  mutableUsers = true;
  users = cfg.additionalUsers;
};
```

Current account extension layer at
`modules/nixos/users/stianrs.nix:14-24`:

```nix
options.modules.users.stianrs = {
  extraGroups = lib.mkOption {
    type = lib.types.listOf lib.types.str;
    default = [ ];
  };

  packages = lib.mkOption {
    type = lib.types.listOf lib.types.package;
    default = [ ];
  };
};
```

Current Home Manager assembly at `modules/flake/hosts.nix:35-44`:

```nix
users.stianrs = {
  imports = [
    config.internal.homeModules.default
    (lib.attrByPath [ hostname ] { } config.internal.homeModules)
  ]
  ++ lib.optionals (!isWSL) [ config.internal.homeModules.desktop ];
  host = {
    name = hostname;
    inherit isWSL;
  };
};
```

Follow the repository's deferred-module convention. For example,
`modules/hosts/gamer.nix` contributes both metadata and a deferred NixOS module
through `internal.*`; raw NixOS declarations must remain inside that deferred
module.

## Commands you will need

| Purpose | Command | Expected on success |
|---------|---------|---------------------|
| Check formatting/evaluation | `nix flake check --no-build` | exit 0; all three NixOS configurations and three packages evaluate |
| Full check | `nix flake check` | exit 0; treefmt check passes |
| Build desktop | `nix build .#nixosConfigurations.gamer.config.system.build.toplevel --no-link` | exit 0 |
| Build laptop | `nix build .#nixosConfigurations.laptop.config.system.build.toplevel --no-link` | exit 0 |
| Build WSL | `nix build .#nixosConfigurations.work.config.system.build.toplevel --no-link` | exit 0 |
| Check whitespace | `git diff --check` | exit 0, no output |

## Scope

**In scope** (the only source files to create, move, modify, or delete):

- `modules/users/stianrs/nixos.nix` (create)
- `modules/users/stianrs/home.nix` (create)
- `modules/nixos/users/model.nix` (delete)
- `modules/nixos/users/stianrs.nix` (delete)
- `modules/home/user.nix` (delete)
- `modules/flake/hosts.nix`
- `plans/README.md` (status only)

**Out of scope**:

- Do not create a generic `internal.users` registry or add options to
  `modules/flake/model.nix`; one user does not justify another abstraction.
- Do not rename `internal.homeModules.default`, `.desktop`, or host-specific
  keys; reusable and host-specific Home Manager features remain under
  `modules/home/`.
- Do not move SSH assets or change authorized keys, UID/GID, home path, shell,
  groups, packages, Git identity, host context, or feature selections.
- Do not change `users.mutableUsers = true`; preserving existing login behavior
  is required.
- Do not generalize `modules/flake/hosts.nix` to multiple users.
- Do not change OpNix, secrets, host hardware, overlays, package recipes, or
  flake inputs.

## Git workflow

- Use branch `advisor/009-simplify-user-configuration` if execution occurs in
  an isolated worktree; otherwise stay on the operator-selected branch.
- Create one logical commit after all checks pass.
- Match the repository's conventional commit style, for example:
  `refactor(users): simplify user configuration`.
- Do not push or open a pull request unless the operator explicitly requests it.

## Steps

### Step 1: Record the pre-refactor behavioral baseline

Before editing, run the following read-only evaluations and retain their output
for comparison:

```bash
nix eval --json .#nixosConfigurations.gamer.config.users.mutableUsers
nix eval --json .#nixosConfigurations.gamer.config.users.users.stianrs --apply 'u: {
  inherit (u) uid name home group isNormalUser description extraGroups;
  shell = u.shell.pname;
  packages = map (p: p.pname or p.name) u.packages;
}'
nix eval --json .#nixosConfigurations.gamer.config.users.groups.stianrs.gid
nix eval --json .#nixosConfigurations.work.config.home-manager.users.stianrs.host
```

The first command must return `true`; the account must have UID/GID 1000 and
home `/home/stianrs`; and the work Home Manager context must identify `work`
with `isWSL = true`. If any command does not evaluate, STOP rather than changing
the query or guessing at the baseline.

**Verify**: `nix flake check --no-build` -> exit 0 before edits.

### Step 2: Move the concrete NixOS account into the user directory

Create `modules/users/stianrs/nixos.nix` as a flake-parts module assigning
`internal.nixosModules.default`. Move the concrete account and primary group
from `modules/nixos/users/stianrs.nix` into it.

Preserve:

- `uid = 1000`, `gid = 1000`, account name, home, description, Fish shell, and
  normal-user status;
- the authorized-key file and newline splitting;
- mandatory `wheel` and `users` groups;
- filtering of optional groups against `config.users.groups`;
- the current optional-group candidates `network`, `networkmanager`,
  `samba-users`, and `docker`.

Remove the `modules.users.stianrs` option layer entirely. Since its `packages`
and `extraGroups` options have no assignments, omit both custom contributions
from the account. Embedded Home Manager currently adds `home-manager-path` to
the final NixOS user package list through `useUserPackages = true`; preserve
that final merged result, but do not hardcode it in the account module. Do not
append a custom extra-group list.

Move `users.mutableUsers = true` from the deleted generic model into this new
deferred module. Delete both old files under `modules/nixos/users/` once their
effective behavior is represented.

The SSH asset remains at `modules/home/_assets/ssh/ssh.pub`. From
`modules/users/stianrs/nixos.nix`, the correct relative path remains
`../../home/_assets/ssh/ssh.pub`.

**Verify**:

```bash
test ! -e modules/nixos/users/model.nix
test ! -e modules/nixos/users/stianrs.nix
test -e modules/users/stianrs/nixos.nix
nix eval --json .#nixosConfigurations.gamer.config.users.mutableUsers
```

Expected: all commands exit 0 and the evaluation returns `true`.

### Step 3: Move personal Home Manager defaults into the user directory

Create `modules/users/stianrs/home.nix` and move the complete deferred Home
Manager module from `modules/home/user.nix` into it. Change only its registration
key from `internal.homeModules.default` to `internal.homeModules.stianrs`.

Preserve the `host.name` and `host.isWSL` option declarations, Git identity,
SSH host settings, WSL conditional, enabled shell features, and Catppuccin
selection exactly. Delete `modules/home/user.nix` after the move.

Do not move reusable feature implementations from `modules/home/`; this file
selects and configures those features for `stianrs`, while `modules/home/`
continues to define them.

**Verify**:

```bash
test ! -e modules/home/user.nix
test -e modules/users/stianrs/home.nix
rg -n 'internal\.homeModules\.stianrs' modules/users/stianrs/home.nix
```

Expected: all commands exit 0 and ripgrep reports the registration in the new
file.

### Step 4: Add the explicit per-user Home Manager import

In `modules/flake/hosts.nix`, add
`config.internal.homeModules.stianrs` to `home-manager.users.stianrs.imports`.
Keep shared default modules first, then the user module, then the optional
host-specific module. Keep the desktop module conditional unchanged.

Target shape:

```nix
imports = [
  config.internal.homeModules.default
  config.internal.homeModules.stianrs
  (lib.attrByPath [ hostname ] { } config.internal.homeModules)
]
++ lib.optionals (!isWSL) [ config.internal.homeModules.desktop ];
```

Keep `home-manager.users.stianrs` explicit. Do not introduce `mapAttrs`, a user
registry, or dynamic account discovery.

**Verify**:

```bash
nix eval --json .#nixosConfigurations.work.config.home-manager.users.stianrs.host
nix eval --json .#nixosConfigurations.gamer.config.home-manager.users.stianrs.host
```

Expected: work reports `name = "work"` and `isWSL = true`; gamer reports
`name = "gamer"` and `isWSL = false`.

### Step 5: Compare behavior and run all gates

Repeat every baseline evaluation from Step 1 and compare the values. Attribute
ordering is irrelevant; values must be identical. Then run all repository
checks and exact host builds.

**Verify**:

```bash
nix flake check
nix build .#nixosConfigurations.gamer.config.system.build.toplevel --no-link
nix build .#nixosConfigurations.laptop.config.system.build.toplevel --no-link
nix build .#nixosConfigurations.work.config.system.build.toplevel --no-link
git diff --check
```

Expected: every command exits 0. If a build fails because a remote substituter
is temporarily unavailable, retry once; if evaluation or local derivation
construction fails, STOP and report the exact failure.

## Test plan

This repository has no dedicated NixOS module test suite. Do not add a new test
framework in this refactor. Use evaluation and exact host builds as the
behavioral tests:

- Compare the selected `stianrs` NixOS account fields before and after.
- Confirm mutable users remain enabled.
- Confirm `work` receives WSL host context and `gamer` receives non-WSL context.
- Evaluate and build all three host outputs.
- Run the full treefmt-backed flake check.

## Done criteria

- [ ] `modules/users/stianrs/{nixos,home}.nix` are the only files containing the
  concrete NixOS account and personal Home Manager defaults, respectively.
- [ ] `modules/nixos/users/model.nix`, `modules/nixos/users/stianrs.nix`, and
  `modules/home/user.nix` no longer exist.
- [ ] `rg 'modules\.users\.(additionalUsers|groups|stianrs)' modules` returns no
  matches.
- [ ] `users.mutableUsers` still evaluates to `true` on all hosts.
- [ ] UID/GID, home, shell, authorized key, groups, and Home Manager host context
  match the Step 1 baseline.
- [ ] `nix flake check` exits 0.
- [ ] Exact builds for `gamer`, `laptop`, and `work` exit 0.
- [ ] `git diff --check` exits 0.
- [ ] No source files outside the Scope list are modified.
- [ ] Plan 009 is marked DONE in `plans/README.md`.

## STOP conditions

Stop and report back instead of improvising if:

- Any in-scope current-state excerpt has drifted materially since commit
  `796f163`.
- Any module outside the listed current files assigns
  `modules.users.additionalUsers`, `modules.users.groups`,
  `modules.users.stianrs.extraGroups`, or `modules.users.stianrs.packages`.
- More than one Home Manager user must be supported now.
- Preserving behavior requires an `internal.users` registry or a change to
  `modules/flake/model.nix`.
- The relative SSH asset path is no longer valid from the new file.
- A verification command fails twice after one reasonable correction.
- The refactor appears to require modifying an out-of-scope source file.

## Maintenance notes

- If a second user is added later, first duplicate the explicit user module and
  host assembly entry. Introduce a typed user registry only after duplicated
  wiring demonstrates a concrete abstraction boundary.
- Keep reusable feature implementations under `modules/home/`; files under
  `modules/users/<name>/` should define the account and select/configure those
  features for that person.
- Reviewers should scrutinize `users.mutableUsers`, optional group filtering,
  authorized-key loading, and the ordering/content of Home Manager imports;
  these are the places where a directory-only refactor can change behavior.
