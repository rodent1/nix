# Plan 007: Validate Workflow And Nvfetcher Configuration Before Merge

> **Executor instructions**: Build on the safe PR event from Plan 002. Keep generated-file checks deterministic and never grant PR code write permissions. Run each gate and stop if nvfetcher cannot be checked reproducibly.
>
> **Drift check (run first)**: `git diff --stat 544a8d8..HEAD -- .github/workflows/check-flake.yaml .github/workflows/build-cache.yaml .github/workflows/nvfetcher.yaml modules/packages/nvfetcher.toml modules/packages/_sources`
> Stop if Plan 002 is not present or generation paths/commands differ from the excerpts.

## Status

- **Priority**: P2
- **Effort**: S
- **Risk**: LOW
- **Depends on**: `plans/002-check-pr-revision.md`, `plans/003-pin-cache-actions.md`
- **Category**: tests
- **Planned at**: commit `544a8d8`, 2026-07-12 (refreshed during reconciliation)

## Why This Matters

The main build workflow reacts only to Nix files and `flake.lock`. Workflow YAML can change without syntax validation, while `nvfetcher.toml` is generated and validated by automation only after reaching `main`. PR validation should cover these control files and prove generated source metadata is synchronized before merge.

## Current State

- `.github/workflows/build-cache.yaml:5-11` triggers only for `**/*.nix` and `flake.lock` on pushes and pull requests.
- `.github/workflows/check-flake.yaml:3-8` now uses the unprivileged `pull_request` event without a path filter, but its `main` push trigger remains limited to `**.nix` and `flake.lock`.
- `.github/workflows/nvfetcher.yaml:40-74` runs nvfetcher in `modules/packages`, then validates packages when changes are generated.
- `modules/packages/nvfetcher.toml` is the source of truth; `_sources/generated.nix` and `_sources/generated.json` are generated and must not be manually edited.
- `AGENTS.md:40` documents the exact local generation command.

## Commands You Will Need

| Purpose | Command | Expected on success |
|---------|---------|---------------------|
| Workflow lint | `nix shell --inputs-from . nixpkgs#actionlint --command actionlint .github/workflows/*.yaml` | exit 0 using this flake's locked `nixpkgs` input |
| Generate sources | `nix-shell -p nvfetcher --command 'nvfetcher -l /tmp/nvfetcher-changes --keep-old'` from `modules/packages/` | exit 0 |
| Consistency | `git diff --exit-code -- modules/packages/_sources` | exit 0 when generated files are current |
| Lightweight flake check | `nix flake check --no-build` | exit 0 |

## Scope

**In scope**:

- `.github/workflows/check-flake.yaml`
- `.github/workflows/build-cache.yaml` path filters only, if needed
- `.github/workflows/nvfetcher.yaml` only if extracting/reusing its exact generation command is necessary
- `.github/workflows/lint-workflows.yaml` (create if separate path filtering is clearer)
- `.github/workflows/check-generated-sources.yaml` (create)
- `plans/README.md` status only

**Out of scope**:

- Editing `modules/packages/nvfetcher.toml` or generated sources
- Upgrading package versions or changing nvfetcher inputs
- Giving PR jobs write permissions, app tokens, service-account credentials, or PR-creation behavior
- Replacing nvfetcher or introducing a general task runner

## Git Workflow

- Suggested branch: `test/non-nix-config`
- Commit message: `test(ci): validate workflow and source config`.
- Do not push or open a PR unless instructed.

## Steps

### Step 1: Broaden Relevant Triggers

Ensure changes to `.github/workflows/*.yaml`, `.renovaterc.json5`, and `modules/packages/nvfetcher.toml` trigger the read-only check workflow on pushes and PRs. Preserve Nix and lockfile coverage. The current `pull_request` event already has no path filter; do not add one. Extend only the filtered `push` event as necessary.

Add `modules/packages/nvfetcher.toml` and generated source paths to the build workflow only if package builds are required when those files change. Do not trigger six expensive builds for unrelated workflow-only edits.

**Verify**: inspect the final event filters and show that a PR changing each control-file class reaches at least one validating job.

### Step 2: Add Workflow Syntax Validation

Create `.github/workflows/lint-workflows.yaml` with read-only `pull_request` and `push` triggers limited to `.github/workflows/**` and `.renovaterc.json5`. Install Nix with the repository's existing immutable installer convention, then run `nix shell --inputs-from . nixpkgs#actionlint --command actionlint .github/workflows/*.yaml`. `--inputs-from .` must resolve `nixpkgs` from this flake's lock rather than an unrelated channel.

Lint all files under `.github/workflows`, not only the changed workflow.

**Verify**: local actionlint exits 0 and deliberate temporary invalid YAML is rejected; revert the mutation immediately.

### Step 3: Add Nvfetcher Drift Validation

Create `.github/workflows/check-generated-sources.yaml` with read-only `pull_request` and `push` triggers limited to `modules/packages/nvfetcher.toml`, `modules/packages/_sources/**`, and this workflow itself. Run the same nvfetcher command documented in `AGENTS.md` from `modules/packages/`, then fail if generated source files differ. Use a temporary change-log path. The job may modify its disposable checkout to compare the diff; it must not commit, push, expose credentials, or create PRs. A separate path-filtered workflow avoids adding an unspecified changed-files action.

Avoid shell word splitting for paths. Keep this separate from the privileged scheduled updater in `nvfetcher.yaml`.

**Verify**: generation followed by `git diff --exit-code -- modules/packages/_sources` exits 0 on the current tree. A temporary harmless formatting/comment change in `nvfetcher.toml` should still execute the job path; revert it afterward.

### Step 4: Validate The Combined Workflow

Run actionlint and `nix flake check --no-build`. Confirm every new third-party action is SHA-pinned and all PR jobs retain `contents: read` only.

**Verify**: all command-table checks pass. `git grep -nE 'pull_request_target|uses: [^ ]+@v[0-9]' -- .github/workflows` returns no matches. Any workflow with `permissions: ... write` has no `pull_request` trigger; the privileged scheduled nvfetcher updater is expected to retain write permissions.

## Test Plan

- actionlint accepts all workflows and rejects a temporary malformed workflow.
- Current nvfetcher configuration regenerates with no source diff.
- A stale generated source mutation makes the consistency check fail; revert the mutation afterward.
- Trigger review covers workflow YAML, Renovate config, nvfetcher config, Nix, and lockfile changes.
- Whole-flake evaluation remains green.

## Done Criteria

- [ ] Workflow YAML is linted on relevant PRs.
- [ ] `nvfetcher.toml` changes are checked against generated sources before merge.
- [ ] Control-file changes trigger appropriate validation.
- [ ] PR jobs are read-only and receive no custom credentials.
- [ ] All Actions are immutable SHA pins.
- [ ] actionlint, generation consistency, and `nix flake check --no-build` pass.
- [ ] Generated files and package versions are unchanged by this plan.
- [ ] `plans/README.md` marks Plan 007 DONE.

## STOP Conditions

Stop if Plan 002 has not replaced `pull_request_target`; nvfetcher requires unavailable credentials/network access in PRs; current generation is already stale; a locked actionlint package cannot be obtained without changing flake inputs; or validation would require write permissions.

## Maintenance Notes

- Keep scheduled update/publishing privileges isolated from read-only PR validation.
- When generator commands change, update CI and `AGENTS.md` together.
