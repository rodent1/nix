# Plan 008: Document The Supported Operator Workflow

> **Executor instructions**: Document only commands verified against the live flake. Do not invent bootstrap or deployment guarantees. Run all lightweight commands before writing and stop if source documentation disagrees.
>
> **Drift check (run first)**: `git diff --stat 33248d4..HEAD -- README.md AGENTS.md flake.nix modules/flake .github/workflows plans/README.md`
> Re-read live output and verification commands if earlier plans changed them; stop if host/package names differ.

## Status

- **Priority**: P2
- **Effort**: S
- **Risk**: LOW
- **Depends on**: `plans/002-check-pr-revision.md`, `plans/007-validate-non-nix-config.md`
- **Category**: docs
- **Planned at**: commit `33248d4`, 2026-07-11

## Why This Matters

The README describes purpose and structure but not how a human inspects, validates, builds, or activates the configuration. Those commands exist only in `AGENTS.md`, and CI's effective validation contract spans multiple workflows. Add a concise operator quick-start that reflects the final post-plan behavior without duplicating maintenance internals.

## Current State

`README.md:18-37` documents the dendritic directory structure, then jumps to references at line 39. `AGENTS.md:27-36` contains the current commands:

```text
nix flake show --all-systems
nix build .#nixosConfigurations.<host>.config.system.build.toplevel
nix build .#flate
nix build .#kubectl-kopiur
nix build .#wagoapp
nh os switch
```

The supported hosts are `laptop`, `gamer`, and `work`; packages are `flate`, `kubectl-kopiur`, and `wagoapp`; system scope is `x86_64-linux`. `programs.nh.flake` is pinned to `/home/stianrs/nix` in `modules/nixos/system/nh.nix:3-8`, so `nh os switch` applies only on machines already using that checkout path. Secrets use opnix and require separate credentials; the README must not expose references or imply a zero-touch fresh install.

## Commands You Will Need

| Purpose | Command | Expected on success |
|---------|---------|---------------------|
| Show outputs | `nix flake show --all-systems` | lists three hosts, three packages, formatter/checks |
| Lightweight validation | `nix flake check --no-build` | exit 0 |
| Host names | `nix eval --json .#nixosConfigurations --apply builtins.attrNames` | `["gamer","laptop","work"]` |
| Package names | `nix eval --json .#packages.x86_64-linux --apply builtins.attrNames` | `["flate","kubectl-kopiur","wagoapp"]` |
| Markdown/style check | `nix build .#checks.x86_64-linux.treefmt` | exit 0 |

## Scope

**In scope**:

- `README.md`
- `AGENTS.md` only to correct drift discovered while documenting
- `plans/README.md` status only

**Out of scope**:

- New scripts, apps, dev shells, installation automation, Disko, or deployment tooling
- Changing commands/configuration to make prose simpler
- Documenting secret references, credential values, generated hardware details, or unsupported fresh-install procedures
- Rewriting the README's visual style or external references

## Git Workflow

- Suggested branch: `docs/operator-quick-start`
- Commit message: `docs: add operator quick start`.
- Do not push or open a PR unless instructed.

## Steps

### Step 1: Re-Establish Live Commands And Outputs

Run `nix flake show --all-systems`, `nix flake check --no-build`, and both attribute-name evaluations from the command table. Treefmt is reserved for Step 4. Inspect the final workflows after Plans 002 and 007 to describe what CI checks, but do not duplicate workflow implementation details.

**Verify**: host/package lists exactly match Current State and all commands exit 0.

### Step 2: Add A Concise Quick-Start Section

Add a section after Structure and before References covering:

1. Prerequisite: Nix with flakes enabled and an `x86_64-linux` system.
2. Inspect outputs with `nix flake show --all-systems`.
3. Run lightweight validation with `nix flake check --no-build` and formatting/full check with `nix flake check`.
4. Build an exact host using the complete `nixosConfigurations.<host>.config.system.build.toplevel` attribute.
5. Build each exported package, with a compact example and the complete name list.
6. On a configured host using `/home/stianrs/nix`, activate with `nh os switch`; clearly state that this changes the running system.
7. Point maintainers to `AGENTS.md` for architecture, nvfetcher, and exact verification guidance.

Use fenced `bash` blocks. Keep the existing personal-repository tone, but prioritize exact copy-pastable commands.

**Verify**: every command named in README occurs in the command table or `AGENTS.md`, and host/package spelling matches evaluations.

### Step 3: Reconcile Agent Guidance

Compare `AGENTS.md` with the final CI/check behavior. Update it only for concrete drift introduced by Plan 007, such as non-Nix validation. Avoid copying the entire README quick-start.

**Verify**: `git diff --check` exits 0; no stale host/package name is present.

### Step 4: Run Documentation Validation

Build treefmt and run `nix flake check --no-build`.

**Verify**: both commands exit 0.

## Test Plan

- Execute every lightweight command printed in README.
- Evaluate host and package names and compare literally with prose.
- Build treefmt to catch Markdown formatting issues.
- Review activation wording to ensure `nh os switch` is not presented as read-only or as a fresh-install command.

## Done Criteria

- [ ] README identifies supported platform, hosts, and packages accurately.
- [ ] README documents inspect, check, exact host build, package build, and activation commands.
- [ ] Activation and secret/bootstrap boundaries are stated honestly.
- [ ] README links to `AGENTS.md` for maintenance detail.
- [ ] `AGENTS.md` matches final checks and workflows without unnecessary duplication.
- [ ] Treefmt and `nix flake check --no-build` pass.
- [ ] Only scoped files changed.
- [ ] `plans/README.md` marks Plan 008 DONE.

## STOP Conditions

Stop if evaluated outputs differ from the documented three hosts/packages, an earlier plan changed the supported verification command, `nh os switch` no longer targets this checkout, or documenting a fresh-install path would require assumptions absent from the repository.

## Maintenance Notes

- Update the output lists whenever `rodent.hosts` or exported packages change.
- Keep README operator-oriented and AGENTS maintenance-oriented.
