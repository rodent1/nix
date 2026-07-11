# Plan 002: Make Flake Checks Validate Every Pull Request Revision

> **Executor instructions**: Follow this plan step by step. Run every verification command and confirm the expected result before moving on. Stop on any condition in "STOP Conditions" instead of improvising. When complete, update this plan's row in `plans/README.md` unless a reviewer maintains the index.
>
> **Drift check (run first)**: `git diff --stat 33248d4..HEAD -- .github/workflows/check-flake.yaml`
> If the file changed, compare it with the excerpts below and stop if its event, permissions, checkout, or check command no longer matches.

## Status

- **Priority**: P1
- **Effort**: S
- **Risk**: LOW
- **Depends on**: none
- **Category**: bug
- **Planned at**: commit `33248d4`, 2026-07-11

## Why This Matters

The current pull-request workflow uses `pull_request_target`, then performs a default checkout. That event runs in the base-repository context, so the job can pass without evaluating the proposed revision. It also omits the `synchronize` activity that follows later pushes. The check must run against every PR revision without exposing repository credentials to contributor-controlled Nix.

## Current State

`.github/workflows/check-flake.yaml:2-6`:

```yaml
on:
  pull_request_target:
    types:
      - opened
      - auto_merge_enabled
```

`.github/workflows/check-flake.yaml:15-21` checks out the default ref and runs `nix flake check`. Lines 17-20 also place `secrets.GITHUB_TOKEN` in Nix's access-token configuration. The workflow does not need that token, write permissions, or any custom secret. `.github/workflows/build-cache.yaml:8-14` is the repository's safer PR pattern: an ordinary `pull_request` trigger plus concurrency cancellation.

Repository convention: pin third-party actions to full commit SHAs and retain a version comment, as shown by `actions/checkout` in this workflow. YAML indentation is two spaces.

## Commands You Will Need

| Purpose | Command | Expected on success |
|---------|---------|---------------------|
| Parse workflows | `nix shell --inputs-from . nixpkgs#actionlint --command actionlint .github/workflows/*.yaml` | exit 0, no findings |
| Validate flake | `nix flake check --no-build` | exit 0; all three hosts and packages evaluate |
| Confirm trigger | `git grep -n 'pull_request_target' -- .github/workflows/check-flake.yaml` | no matches |

## Scope

**In scope**:

- `.github/workflows/check-flake.yaml`
- `plans/README.md` status only

**Out of scope**:

- `.github/workflows/build-cache.yaml`; action pinning is Plan 003
- Broader path triggers and nvfetcher consistency; those are Plan 007
- Adding secrets, write permissions, privileged events, or explicit checkout of untrusted code under `pull_request_target`
- Nix source changes

## Git Workflow

- Suggested branch: `fix/check-pr-revision`
- Use a conventional commit such as `fix(ci): check pull request revisions`.
- Do not push or open a PR unless instructed.

## Steps

### Step 1: Replace The Privileged PR Event

Change `pull_request_target` to ordinary `pull_request`. Do not restrict activity types: GitHub's defaults include opening, reopening, and synchronization. Retain the existing `push` trigger. Add explicit top-level `permissions: contents: read` so the trust boundary is visible. Remove the `extra_nix_config` block that exports `secrets.GITHUB_TOKEN` as a Nix access token; PR-controlled evaluation must receive no token.

Do not add `pull_request_target`, `workflow_run`, secrets, write permissions, or a manually interpolated PR head repository/ref.

**Verify**: `git grep -nE 'pull_request_target|contents: write|secrets\.|access-tokens' -- .github/workflows/check-flake.yaml` returns no matches, and `git grep -n 'pull_request:' -- .github/workflows/check-flake.yaml` returns exactly one trigger.

### Step 2: Add Concurrency Cancellation

Match `.github/workflows/build-cache.yaml:12-14`: group by workflow and PR number/ref and cancel superseded runs. Keep default `actions/checkout` behavior; on `pull_request`, it checks the tested merge revision without requiring credentials.

**Verify**: `nix shell --inputs-from . nixpkgs#actionlint --command actionlint .github/workflows/check-flake.yaml` exits 0.

### Step 3: Run Local Evaluation

Run `nix flake check --no-build`. This verifies that changing CI did not conceal a pre-existing evaluation failure.

**Verify**: the command exits 0 and reports `gamer`, `laptop`, `work`, `flate`, `kubectl-kopiur`, and `wagoapp` during evaluation.

## Test Plan

- Static workflow test: actionlint accepts the workflow.
- Trust test: no `pull_request_target`, write permission, secret reference, or Nix access-token injection exists in the check workflow.
- Event test: ordinary `pull_request` has no activity filter, so synchronized commits are included.
- Repository test: `nix flake check --no-build` passes locally.
- After opening the eventual PR, push a harmless follow-up commit and confirm a new Check Flakes run is created for that commit. This GitHub-side observation cannot be completed locally.

## Done Criteria

- [ ] `.github/workflows/check-flake.yaml` uses ordinary `pull_request` with no restrictive activity list.
- [ ] Top-level permissions are read-only.
- [ ] Superseded PR runs are cancelled by concurrency configuration.
- [ ] Default checkout tests the `pull_request` merge revision.
- [ ] actionlint and `nix flake check --no-build` exit 0.
- [ ] No file outside scope is modified.
- [ ] `plans/README.md` marks Plan 002 DONE.

## STOP Conditions

Stop and report if the workflow has gained a requirement for repository secrets, write permissions, or base-context execution since commit `33248d4`; if branch protection explicitly requires behavior incompatible with ordinary `pull_request`; or if actionlint reports unrelated pre-existing errors that cannot be isolated from this file.

## Maintenance Notes

- Keep checks that execute PR-controlled Nix on unprivileged events.
- Reviewers should verify the Actions UI shows the PR's latest commit, not merely trust the YAML diff.
- Plan 007 broadens validation paths after this trust boundary is corrected.
