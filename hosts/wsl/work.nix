{ lib, ... }:
{
  imports = [ ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
