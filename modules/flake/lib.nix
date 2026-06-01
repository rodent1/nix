{
  inputs,
  self,
  ...
}:
let
  mkPkgsWithSystem =
    system:
    import inputs.nixpkgs {
      inherit system;
      overlays = builtins.attrValues self.overlays;
      config.allowUnfree = true;
    };
in
{
  flake.lib = {
    inherit mkPkgsWithSystem;
  };

  perSystem =
    { system, ... }:
    {
      _module.args.pkgs = mkPkgsWithSystem system;
    };
}
