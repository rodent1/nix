# Plan 004: Scope The WSL 1Password Credential To Explicit Commands

> **Executor instructions**: This plan handles credential plumbing. Never print, log, inspect, or reproduce the credential value. Follow verification commands exactly and stop rather than broadening exposure. Update the status row when complete unless instructed otherwise.
>
> **Drift check (run first)**: `git diff --stat 33248d4..HEAD -- modules/home/security/opnix/default.nix modules/home/security/1password/default.nix modules/home/development/utilities/opencode.nix`
> Stop if token materialization, WSL guards, or consumers differ from the current state.

## Status

- **Priority**: P1
- **Effort**: S
- **Risk**: MED
- **Depends on**: none
- **Category**: security
- **Planned at**: commit `33248d4`, 2026-07-11

## Why This Matters

On WSL, Fish reads a mode-`0600` service-account credential and exports it globally at login. Every descendant process then inherits the long-lived credential, including developer tools, diagnostics, and subprocesses that do not need it. Keep the protected file but load the credential only for an explicitly named command that requires it.

## Current State

`modules/home/security/opnix/default.nix:28-32` creates the WSL-only credential file under the user's 1Password configuration directory with mode `0600`. Do not reproduce its contents or secret reference in logs or tests.

`modules/home/security/1password/default.nix:18-20` currently contains:

```nix
programs.fish.loginShellInit = lib.mkIf config.rodent.isWSL ''
  set -gx OP_SERVICE_ACCOUNT_TOKEN (cat ${config.xdg.configHome}/1Password/op-service-account-token)
'';
```

Home Manager Fish functions are declared as attribute sets; examples are `modules/home/kubernetes/default.nix:48-59` and `modules/home/shell/fish/default.nix:56-65`. Preserve `config.rodent.isWSL`: physical hosts use the desktop 1Password agent and must not read this file.

## Commands You Will Need

| Purpose | Command | Expected on success |
|---------|---------|---------------------|
| Locate consumers | `git grep -n 'OP_SERVICE_ACCOUNT_TOKEN' -- ':!plans/**'` | only intentional scoped consumer and secret declaration remain |
| Evaluate work wrapper | `nix eval --raw .#nixosConfigurations.work.config.home-manager.users.stianrs.programs.fish.functions.op.body` | exits 0; body contains the scoped wrapper but no credential value |
| Validate flake | `nix flake check --no-build` | exit 0 |
| Build work | `nix build .#nixosConfigurations.work.config.system.build.toplevel` | exit 0 |

## Scope

**In scope**:

- `modules/home/security/1password/default.nix`
- `plans/README.md` status only

**Read-only investigation allowed**:

- Other maintained modules to inventory consumers

**Out of scope**:

- Changing secret references, token files, opnix configuration, permissions, or physical-host 1Password agent behavior
- Printing or testing the credential value
- Adding the credential to `home.sessionVariables`, process-wide environment, command history, generated world-readable files, or the Nix store
- Rotating the credential; recommend rotation separately if exposure is suspected

## Git Workflow

- Suggested branch: `security/scope-onepassword-token`
- Commit message: `fix(security): scope WSL 1Password token`.
- Do not push or open a PR unless instructed.

## Steps

### Step 1: Inventory Actual Consumers

Search maintained source and documentation for the environment variable. Determine which command needs service-account authentication on WSL. The expected repository state is that only Fish globally exports it and no other module consumes it.

If repository evidence does not identify the intended command, ask the operator whether the `op` CLI is the sole consumer. Do not guess or remove working authentication.

**Verify**: record only consumer locations and command names, never the credential or file contents.

### Step 2: Replace Global Export With A Command-Scoped Fish Function

If the operator confirms `op` is the sole consumer, add `pkgs` to the lower-level module arguments and replace `loginShellInit` with a WSL-only `programs.fish.functions.op` definition. Confirm the live nixpkgs attribute for the 1Password CLI first. The body must use the absolute `${pkgs.<confirmed-1password-cli-attribute>}/bin/op` binary through `env`, assign `OP_SERVICE_ACCOUNT_TOKEN` from a quoted command substitution reading the protected file, and forward `$argv`. Do not use `env ... command op`: `command` is a Fish builtin and would be treated as an external executable by `env`.

If more than one command legitimately needs the token, STOP and propose a small command-wrapper abstraction rather than exporting it globally.

**Verify**: `git grep -nE 'set -gx OP_SERVICE_ACCOUNT_TOKEN|home\.sessionVariables.*OP_SERVICE_ACCOUNT_TOKEN' -- modules` returns no matches. `git grep -n 'op-service-account-token' -- modules` returns exactly the secret destination and scoped wrapper locations.

### Step 3: Evaluate Both Host Classes

Evaluate/build `work` and run whole-flake validation. Also evaluate a physical host's Fish configuration to ensure it does not contain the wrapper or token file path.

**Verify**: `nix flake check --no-build` and the work build exit 0. `nix eval --json .#nixosConfigurations.work.config.home-manager.users.stianrs.programs.fish.functions --apply 'functions: functions ? op'` prints `true`; the same command for `laptop` prints `false`. Evaluate the work function body and confirm it contains the protected path and absolute `op` binary without displaying any credential value.

## Test Plan

- Source test: no global export remains.
- WSL evaluation: the scoped function is present only for `work`.
- Physical-host evaluation: laptop configuration has neither wrapper credential loading nor token path.
- Integration test on WSL after activation: a fresh Fish shell does not include `OP_SERVICE_ACCOUNT_TOKEN` in `env`; the confirmed command still authenticates. Do not print the variable's value while testing.

## Done Criteria

- [ ] A fresh WSL Fish shell does not globally export the credential.
- [ ] Only the confirmed command receives it for its process lifetime.
- [ ] No secret value enters source, logs, tests, command history, or the Nix store.
- [ ] Physical-host behavior is unchanged.
- [ ] `nix flake check --no-build` and the exact work build pass.
- [ ] Only scoped files changed.
- [ ] `plans/README.md` marks Plan 004 DONE.

## STOP Conditions

Stop if the intended consumers cannot be established from code/operator confirmation; more than one unrelated tool needs the variable; the wrapper would interpolate the credential into a Nix-generated store file; the protected file is absent before Fish use; or authentication requires a broader session environment.

## Maintenance Notes

- Future tools must request explicit credential scope rather than relying on ambient shell state.
- Reviewers must inspect generated Fish code without running commands that reveal the value.
