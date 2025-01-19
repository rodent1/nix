# Definitions can be imported from a separate file like this one

{ self, lib, ... }:
{
  perSystem =
    {
      config,
      self',
      inputs',
      pkgs,
      ...
    }:
    {
      # Definitions like this are entirely equivalent to the ones
      # you may have directly in flake.nix.
      packages.hello = pkgs.hello;
    };
  flake = {
    nixosModules.lib =
      { pkgs, ... }:
      {
        # System lib functions can be defined here
      };
  };
}
