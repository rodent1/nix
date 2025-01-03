{ inputs, ... }:
let
  overlays = system: [
    inputs.rust-overlay.overlays.default

    (final: prev: {
      unstable = import inputs.nixpkgs-unstable {
        inherit (final) system;
        config.allowUnfree = true;
      };
    })

    (final: prev: {
      # Packages from inputs
    })

    (
      final: prev:
      import ../pkgs {
        inherit inputs system;
        pkgs = final;
      }
    )
  ];
in
{
  perSystem =
    { system, ... }:
    {
      _module.args = {
        overlays = overlays system;
      };
    };
}
