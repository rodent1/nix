{ inputs, ... }:
{
  perSystem =
    { system, ... }:
    {
      _module.args.pkgs = import inputs.nixpkgs {
        # Configure pkgs
        inherit system;
        config.allowUnfree = true;

        # Add overlays
        overlays = [
          # Add overlays from inputs
          inputs.rust-overlay.overlays.default

          # Add the unstable channel of nixpkgs
          (final: prev: {
            unstable = import inputs.nixpkgs-unstable {
              inherit (final) system;
              config.allowUnfree = true;
            };
          })

          # Packages from inputs
          (final: prev: {
            talhelper = inputs.talhelper.packages.${system}.default;
          })

          # Add the packages from this flake to pkgs
          (
            final: prev:
            import ../pkgs {
              inherit inputs system;
              pkgs = final;
            }
          )
        ];
      };
    };
}
