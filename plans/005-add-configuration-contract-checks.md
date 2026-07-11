# Plan 005: Add Evaluation Checks For Critical Flake Contracts

> **Executor instructions**: Add only inexpensive evaluation assertions; do not redesign host wiring. Run every gate and stop on recursion or undocumented behavior. Update the index status when complete unless told otherwise.
>
> **Drift check (run first)**: `git diff --stat 33248d4..HEAD -- modules/flake modules/hosts modules/home/hosts`
> Stop if the host/package sets, WSL classification, or embedded Home Manager wiring no longer match the excerpts.

## Status

- **Priority**: P1
- **Effort**: M
- **Risk**: LOW
- **Depends on**: none
- **Category**: tests
- **Planned at**: commit `33248d4`, 2026-07-11

## Why This Matters

`nix flake check` evaluates all outputs and treefmt, but it does not assert the repository's intended semantic contract. A refactor can keep outputs buildable while changing which host is WSL, importing desktop Home Manager into WSL, dropping the embedded user, or changing the public host/package set. Add fast checks that fail with specific messages before behavioral fixes rely on them.

## Current State

- `modules/flake/core.nix:2` supports only `x86_64-linux`.
- `modules/flake/hosts.nix:31-55` embeds Home Manager user `stianrs`, excludes desktop Home Manager when `isWSL`, and includes NixOS-WSL only for WSL.
- `modules/hosts/{laptop,gamer,work}.nix:2-5` declares exactly three hosts; only `work` has `isWSL = true`.
- `modules/packages/{flate,kubectl-kopiur,wagoapp}.nix` exports exactly three packages.
- `modules/flake/treefmt.nix:5-13` currently contributes the only explicit check, named `treefmt`.

All maintained `.nix` files under `modules/` are auto-imported flake-parts modules. New raw helper expressions must be under an underscore-prefixed path; prefer one auto-imported `modules/flake/checks.nix` module.

## Commands You Will Need

| Purpose | Command | Expected on success |
|---------|---------|---------------------|
| List checks | `nix eval --json .#checks.x86_64-linux --apply builtins.attrNames` | includes `configuration-contract` and `treefmt` |
| Build contract | `nix build .#checks.x86_64-linux.configuration-contract` | exit 0 |
| Full evaluation | `nix flake check --no-build` | exit 0 |
| Host names | `nix eval --json .#nixosConfigurations --apply builtins.attrNames` | `["gamer","laptop","work"]` |
| Package names | `nix eval --json .#packages.x86_64-linux --apply builtins.attrNames` | `["flate","kubectl-kopiur","wagoapp"]` |

## Scope

**In scope**:

- `modules/flake/checks.nix` (create)
- Minimal changes to `modules/flake/model.nix` only if a typed internal contract value is needed to avoid evaluation recursion
- `plans/README.md` status only

**Out of scope**:

- Changing host metadata, package exports, WSL/desktop behavior, or output names to make tests pass
- VM tests, installation tests, closure builds, or a general Nix test framework
- Moving existing modules or changing the import-tree architecture
- Password wiring; Plan 006 consumes this baseline

## Git Workflow

- Suggested branch: `test/configuration-contracts`
- Commit message: `test(flake): assert configuration contracts`.
- Do not push or open a PR unless instructed.

## Steps

### Step 1: Establish Contract Values

Create `modules/flake/checks.nix` as an auto-imported flake-parts module. Build one derivation named `checks.configuration-contract` that evaluates assertions before creating an empty `$out`. Use `pkgs.runCommand` or an equivalently tiny derivation; no network or host build is needed.

Assert these stable contracts with individual, descriptive failure messages:

1. Host names are exactly `gamer`, `laptop`, and `work`.
2. Public `packages.x86_64-linux` names are exactly `flate`, `kubectl-kopiur`, and `wagoapp`; checking recipe registrations alone is insufficient because registration and export are separate declarations.
3. Every host system is `x86_64-linux`.
4. Only `work` is classified as WSL.
5. Every evaluated host contains embedded Home Manager user `stianrs`.
6. `work.config.wsl.enable` is true.
7. `work` does not import the desktop Home Manager deferred module. Identify an option or attribute uniquely declared by `rodent.homeModules.desktop`, prove it is absent from `work`, and mutate the actual desktop import guard for the failure test. Do not use `modules.desktop.enable`: that shared option can exist and default false even when the desktop deferred module is excluded.

Assertions must validate production values, not duplicate a second hardcoded model disconnected from them. Guard the derivation itself with nested `assert lib.assertMsg condition "message";` expressions, or force a complete assertion list with `builtins.deepSeq` before returning `pkgs.runCommand`; an unused lazy list does not execute assertions. If reading live public outputs from `perSystem` creates recursion, STOP rather than substituting recipe registrations for package-output coverage.

**Verify**: `nix eval --json .#checks.x86_64-linux --apply builtins.attrNames` includes both checks and completes without infinite recursion.

### Step 2: Prove Each Assertion Can Fail

For each assertion category, temporarily invert or alter the expected value one at a time, run the contract build, and confirm the named assertion fails. Revert each temporary mutation immediately; none belongs in the final diff. At minimum exercise host set, WSL classification, embedded user, and desktop exclusion.

**Verify**: each deliberate mutation fails with its intended message; after restoration `git diff --check` and the contract build pass.

### Step 3: Run Repository Validation

Run output-name evaluations, contract build, and `nix flake check --no-build`.

**Verify**: all commands in the command table produce the expected results.

## Test Plan

- The new check itself is the test suite; each assertion has one contract and one descriptive failure.
- Mutation testing in Step 2 demonstrates the assertions observe real configuration rather than constants.
- Existing treefmt remains present and passing.
- No host closure build is required for this evaluation-only plan, but run one if assertion implementation forces more than evaluation and report why.

## Done Criteria

- [ ] `checks.x86_64-linux.configuration-contract` exists and builds.
- [ ] All seven contracts above are asserted against live configuration.
- [ ] Deliberate mutations produce descriptive failures.
- [ ] No assertion causes per-system/host evaluation recursion.
- [ ] Existing output names and treefmt check remain unchanged.
- [ ] `nix flake check --no-build` exits 0.
- [ ] Only scoped files changed.
- [ ] `plans/README.md` marks Plan 005 DONE.

## STOP Conditions

Stop if referencing evaluated hosts from a check creates a flake-parts `withSystem` recursion; a stable desktop-exclusion sentinel cannot be identified; assertions require importing modules a second time; or satisfying a test requires changing production behavior. Report the exact evaluation trace and proposed narrower contract rather than suppressing the assertion.

## Maintenance Notes

- Update expected host/package sets deliberately whenever public outputs change.
- Keep assertions semantic and cheap; exact host/package builds remain CI integration coverage.
- Reviewers should reject tests that merely compare hardcoded values to other hardcoded values.
