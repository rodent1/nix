# Plan 006: Apply The Provisioned Password After Opnix Materialization

> **Executor instructions**: Treat all secret material as sensitive. Never read, print, or reproduce the password hash or secret reference. Add a regression assertion before changing behavior. Stop on ambiguity about opnix paths or activation order. Update the plan status when complete unless told otherwise.
>
> **Drift check (run first)**: `git diff --stat 33248d4..HEAD -- modules/nixos/services/opnix.nix modules/nixos/users/stianrs.nix modules/nixos/users/model.nix modules/flake/checks.nix`
> Stop if the user option, secret declaration, opnix service ordering, mutable-user policy, or contract-check structure changed.

## Status

- **Priority**: P1
- **Effort**: M
- **Risk**: MED
- **Depends on**: `plans/005-add-configuration-contract-checks.md`
- **Category**: bug
- **Planned at**: commit `33248d4`, 2026-07-11

## Why This Matters

The system provisions a root-owned hashed-password secret, while the `stianrs` user exposes a `hashedPasswordFile` option that defaults to `null`. Directly connecting the runtime path is not valid: pinned opnix materializes secrets in `opnix-secrets.service`, after NixOS activation has already managed users. Apply the encrypted hash through a tightly ordered root-only oneshot after opnix instead, without exposing it through process arguments or the Nix store.

## Current State

`modules/nixos/services/opnix.nix:10-16` declares the root-only hashed-password secret. Do not copy its reference into plan output or command logs.

`modules/nixos/users/stianrs.nix:20-23`:

```nix
hashedPasswordFile = lib.mkOption {
  type = lib.types.nullOr lib.types.str;
  default = null;
};
```

At lines 58-60 it forwards the option only when non-null. `modules/nixos/users/model.nix:19-23` deliberately keeps `users.mutableUsers = true`; do not change that policy. The pinned opnix module materializes NixOS secrets from `opnix-secrets.service`, wanted by `multi-user.target`; this is too late for `hashedPasswordFile`. Confirm the service name and supported `config.services.onepassword-secrets.secretPaths.hashedPassword`-style runtime path in the pinned source before implementing the ordered consumer.

## Commands You Will Need

| Purpose | Command | Expected on success |
|---------|---------|---------------------|
| Preserve activation input | `nix eval .#nixosConfigurations.work.config.users.users.stianrs.hashedPasswordFile --json` | remains `null`; late opnix path is not wired into activation |
| Contract check | `nix build .#checks.x86_64-linux.configuration-contract` | exit 0 after fix |
| Full evaluation | `nix flake check --no-build` | exit 0 |
| Exact work build | `nix build .#nixosConfigurations.work.config.system.build.toplevel` | exit 0 |

## Scope

**In scope**:

- `modules/nixos/services/opnix.nix`
- `modules/nixos/users/stianrs.nix` only to document why the late opnix secret must not be its default
- `modules/flake/checks.nix` for the regression assertion
- `plans/README.md` status only

**Out of scope**:

- Secret values/references, password rotation, SSH keys, sudo policy, user identity, UID/GID, or `mutableUsers`
- Other opnix-managed secrets
- Hardcoding runtime paths not guaranteed by the pinned opnix module
- Passing the password hash through command arguments or embedding it in a Nix-generated script
- Reading the realized password hash

## Git Workflow

- Suggested branch: `fix/connect-password-secret`
- Commit message: `fix(users): apply password after secret materialization`.
- Do not push or open a PR unless instructed.

## Steps

### Step 1: Confirm The Pinned Opnix Service Contract

Inspect the pinned opnix NixOS module from the flake input or evaluated options. Confirm the materializing systemd service name, the supported runtime-path attribute for the named secret, file ownership/mode behavior, and failure behavior. Confirm in NixOS source that user activation precedes this service and therefore `hashedPasswordFile` cannot consume it. Do not inspect secret contents.

**Verify**: identify a documented/evaluated runtime-path expression and systemd service dependency. The expression must not place secret data in the Nix store; `hashedPasswordFile` must still evaluate to `null`.

### Step 2: Add A Failing Regression Contract

Extend Plan 005's `configuration-contract` check to assert that every host enables an ordered password-application service, that it requires and starts after the confirmed opnix service, and that `hashedPasswordFile` remains null rather than referencing a late runtime file. Confirm the new assertion fails before production wiring changes, then retain it.

**Verify**: contract build fails with a specific `stianrs password application service is missing`-style message before Step 3.

### Step 3: Add An Ordered Root-Only Password Application Service

In `modules/nixos/services/opnix.nix`, declare a root-run oneshot systemd service adjacent to the secret. It must `requires` and run `after` the confirmed opnix materialization service, be wanted by `multi-user.target`, and fail if the secret is unavailable. Feed the encrypted hash to `${pkgs.shadow}/bin/chpasswd -e` through standard input in `user:hash` format; do not pass the hash as an argument, interpolate it into the Nix expression, or copy it to another file. Use a minimal root-only runtime shell pipeline with strict failure handling and an absolute binary path. Keep secret ownership/mode unchanged.

This service will reassert the declarative password after successful opnix materialization on each boot. Document that behavior in the module. Do not change the user option default or assign the late path to `hashedPasswordFile`.

**Verify**: for all hosts, evaluate the service's `after`, `requires`, `wantedBy`, `serviceConfig.Type`, and script. Ordering names match pinned opnix, type is `oneshot`, and the script references the runtime path plus `chpasswd -e` without containing hash data. The contract check passes and `hashedPasswordFile` remains null.

### Step 4: Build The Most Sensitive Target

Run whole-flake evaluation and the exact `work` system build. Inspect only path-limited source diffs and evaluated service metadata; never read the runtime file or run a broad scanner that prints matching content.

**Verify**: both commands exit 0. Inspect `git diff -- modules/nixos/services/opnix.nix modules/nixos/users/stianrs.nix modules/flake/checks.nix` without invoking commands that print runtime secret files; the declaration's reference line is unchanged and additions contain only path/service plumbing.

## Test Plan

- Regression assertion: all hosts have the ordered service and keep the invalid activation-time password input null.
- Evaluation: check systemd dependency metadata and script references without reading the secret file.
- Integration: exact `work` build validates service construction, but cannot prove runtime ordering alone.
- Operational test after separately approved deployment: retain a working root/login session, confirm opnix completes before the password service, then verify login/sudo before closing the old session. This plan must not switch the live system.

## Done Criteria

- [ ] Pinned opnix source confirms the chosen runtime path/API.
- [ ] A root-only oneshot consumes the secret through stdin after successful opnix materialization.
- [ ] Contract check fails before and passes after the fix.
- [ ] All three hosts expose correct systemd ordering and keep `hashedPasswordFile = null`.
- [ ] Secret ownership/mode and mutable-user policy are unchanged.
- [ ] `nix flake check --no-build` and exact work build pass.
- [ ] No secret value appears in source, logs, or diff.
- [ ] `plans/README.md` marks Plan 006 DONE.

## STOP Conditions

Stop if opnix exposes no stable runtime path/service dependency; `chpasswd -e` is unavailable or incompatible with the stored hash format; the service cannot consume the hash without argv/store exposure; reasserting the password on every boot is not acceptable to the operator; contract checks from Plan 005 are absent; or the fix requires changing credentials or mutable-user policy.

## Maintenance Notes

- Keep secret declaration and its ordered consumer adjacent.
- Reviewers should scrutinize systemd ordering, stdin-only hash handling, and ensure no secret material enters argv or the Nix store.
- Deployment should retain a working root/login session until authentication is verified.
