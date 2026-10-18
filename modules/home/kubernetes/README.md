# Kubernetes CLI plugins

Kubernetes CLI plugins are managed with [Krew](https://krew.sigs.k8s.io/), configured through Home Manager.

## First-time setup

After activating the Home Manager configuration on a new host, initialize Krew by installing its own plugin:

```sh
krew install krew
```

Then install the recommended plugins using `kubectl`:

```sh
kubectl krew install \
  browse-pvc \
  cnpg \
  kopiur \
  node-shell \
  rook-ceph \
  view-secret
```

### Recommended plugins

| Plugin | Purpose |
|---|---|
| `browse-pvc` | Browse Kubernetes persistent volume claims |
| `cnpg` | Manage CloudNativePG PostgreSQL clusters |
| `kopiur` | Operate the kopiur backup operator |
| `node-shell` | Open a shell on Kubernetes nodes |
| `rook-ceph` | Inspect and manage Rook-Ceph storage |
| `view-secret` | Decode and inspect Kubernetes secrets |

These match the plugins used in the existing home-ops environment.

## Verification

List installed plugins:

```sh
kubectl krew list
```

Check for available updates:

```sh
kubectl krew update
kubectl krew upgrade
```

Krew plugins are installed per user and are not automatically installed or upgraded by Home Manager. Repeat the initial setup on each new host.