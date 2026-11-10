# Nix configuration

Declarative configuration for the machines this repository manages and for the
user account on them.

## Hosts

**Host**:
A machine this flake configures, named by its hostname: `laptop`, `gamer` or `work`.
_Avoid_: machine, system, node

**Physical host**:
A host installed directly on its own hardware.
_Avoid_: bare-metal host, native host

**WSL host**:
A host that runs inside Windows Subsystem for Linux, selected by setting `wsl.enable` in its host bundle. It never has a desktop session.
_Avoid_: work machine

## Configuration

**System configuration**:
The machine-wide configuration of a host.
_Avoid_: OS config

**Home configuration**:
The configuration of the user's own environment on a host.
_Avoid_: dotfiles, user config

**Bundle**:
A named set of configuration that is applied to a host as a whole.
_Avoid_: profile, role, fragment, layer

**Default bundle**:
The bundle every host receives.
_Avoid_: base, common

**Host bundle**:
The bundle that only one host receives, named after that host. It holds the host's system configuration and the host-specific part of its home configuration, in `modules/hosts/<host>.nix`.
_Avoid_: host fragment, hostconfig

**Desktop bundle**:
The home configuration that belongs to the desktop session, received only by hosts that have one.

## Desktop

**Desktop session**:
The graphical Hyprland and Noctalia environment. A host selects it as a whole and has either all of it or none of it.
_Avoid_: desktop environment, DE, GUI

## Packages

**Package recipe**:
A package build definition maintained in this repository rather than taken from nixpkgs.
_Avoid_: custom package, local derivation
