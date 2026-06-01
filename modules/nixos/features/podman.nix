{ ... }:
{
  flake.nixosModules.podman = import ../../../hosts/_modules/nixos/services/podman;
}
