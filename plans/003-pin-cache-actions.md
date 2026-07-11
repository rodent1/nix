# Plan 003: Pin Cache-Building Actions To Immutable Commits

> **Executor instructions**: Follow each step and verification gate. Never copy credentials into logs or files. Stop on any listed STOP condition. Update only this plan's status row when done unless told otherwise.
>
> **Drift check (run first)**: `git diff --stat 33248d4..HEAD -- .github/workflows/build-cache.yaml .renovaterc.json5`
> Stop if action names, versions, credential handling, or Renovate rules differ from the current-state excerpts.

## Status

- **Priority**: P1
- **Effort**: S
- **Risk**: LOW
- **Depends on**: none
- **Category**: security
- **Planned at**: commit `33248d4`, 2026-07-11

## Why This Matters

Six steps in the cache-build workflow use mutable major-version tags. These actions execute in jobs that receive a cache publication credential, so an upstream tag move could change privileged CI code without a repository diff. Full commit pins restore reviewable, reproducible action provenance while preserving Renovate updates.

## Current State

`.github/workflows/build-cache.yaml` uses immutable checkout pins but mutable tags for:

```yaml
- uses: DeterminateSystems/nix-installer-action@v21
- uses: DeterminateSystems/magic-nix-cache-action@v13
- uses: cachix/cachix-action@v17
```

The latter three patterns occur in discovery/build jobs; cache jobs pass a credential at lines 41-44 and 60-63. `.github/workflows/check-flake.yaml:15-16` shows the convention to match: 40-character SHA followed by `# vX.Y.Z`. `.renovaterc.json5:21-39` already lets Renovate manage GitHub Actions, including digest updates.

## Commands You Will Need

| Purpose | Command | Expected on success |
|---------|---------|---------------------|
| Resolve tag | `git ls-remote https://github.com/OWNER/REPO.git refs/tags/TAG refs/tags/TAG^{}` | trusted upstream returns tag/peeled commit refs |
| Find mutable uses | `git grep -nE 'uses: [^ ]+@v[0-9]' -- .github/workflows` | no matches after change |
| Workflow lint | `nix shell --inputs-from . nixpkgs#actionlint --command actionlint .github/workflows/build-cache.yaml` | exit 0 |
| Flake evaluation | `nix flake check --no-build` | exit 0 |

## Scope

**In scope**:

- `.github/workflows/build-cache.yaml`
- `plans/README.md` status only

**Out of scope**:

- Updating action major versions or changing installers/caches
- Changing credentials, cache names, workflow permissions, matrices, or build commands
- Editing `.renovaterc.json5`; existing automation should remain intact
- Rotating credentials unless the operator separately determines compromise occurred

## Git Workflow

- Suggested branch: `security/pin-cache-actions`
- Commit message: `chore(ci): pin cache actions by digest`.
- Do not push or create a PR unless instructed.

## Steps

### Step 1: Resolve Trusted Commit Pins

For each current tag (`v21`, `v13`, `v17`), determine the exact current release version and immutable commit from the action's official repository. Prefer the commit represented by the current tag, not a newer major. Verify repository ownership and compare release/tag metadata; for annotated tags use the peeled `^{}` commit. Record only public SHAs and versions.

**Verify**: each selected pin is exactly 40 lowercase hexadecimal characters and belongs to the named official repository.

### Step 2: Replace Every Mutable Tag

Replace all occurrences for the three actions with the verified full SHA and add the resolved version comment. Repeated uses of the same action/version must use the same SHA. Do not alter any `with`, environment, job, or matrix content.

**Verify**: `git grep -nE 'uses: (DeterminateSystems/(nix-installer-action|magic-nix-cache-action)|cachix/cachix-action)@v' -- .github/workflows/build-cache.yaml` returns no matches. `git diff --check` exits 0.

### Step 3: Validate Automation Compatibility

Run actionlint and inspect `.renovaterc.json5:21-39` without editing it. Confirm Renovate's `github-actions` manager remains enabled and the pins retain version comments that make future digest PRs readable.

**Verify**: actionlint exits 0; `git diff -- .renovaterc.json5` is empty.

## Test Plan

- Static grep proves no mutable major tag remains in any workflow.
- actionlint validates workflow syntax.
- `nix flake check --no-build` confirms the repository baseline.
- The eventual PR's `discover`, `build-hosts`, and `build-packages` jobs must all start successfully; this is the integration test for pin validity.

## Done Criteria

- [ ] Every GitHub Action under `.github/workflows` is pinned to a full SHA.
- [ ] The three affected actions retain human-readable version comments.
- [ ] No action major version or workflow behavior changed.
- [ ] actionlint and `nix flake check --no-build` pass.
- [ ] Only scoped files changed.
- [ ] `plans/README.md` marks Plan 003 DONE.

## STOP Conditions

Stop if a tag cannot be tied unambiguously to a commit in the official repository, a selected release is revoked or reports a security concern, Renovate cannot recognize digest-pinned Actions, or the change appears to require credential rotation. Report the affected action without exposing any credential.

## Maintenance Notes

- Continue accepting action updates only as reviewed SHA changes.
- Reviewers should compare each SHA against official release metadata, not merely check its length.
