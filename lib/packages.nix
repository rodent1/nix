{ inputs, ... }:
{
  perSystem =
    { system, ... }:
    let
      # Import pkgs with overlays and configurations applied
      pkgs = import inputs.nixpkgs {
        inherit system;
        config.allowUnfree = true;
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
        ];
      };

      # Import custom packages
      customPkgs = import ../pkgs {
        inherit inputs system;
        pkgs = pkgs;
      };

    in
    {
      # Reference the single imported instance of ../pkgs
      packages = customPkgs;

      # Extend the pkgs attribute set with custom packages
      _module.args.pkgs = pkgs.extend (final: prev: customPkgs);
    };
}
