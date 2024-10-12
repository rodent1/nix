{ inputs, ... }:
{
  rust-overlay = inputs.rust-overlay.overlays.default;
  jeezyvim = inputs.jeezyvim.overlays.default;

  additions =
    final: _prev:
    import ../pkgs {
      inherit inputs;
      pkgs = final;
    };

  # The unstable nixpkgs set (declared in the flake inputs) will
  # be accessible through `pkgs.unstable`
  unstable-packages = final: _prev: {
    unstable = import inputs.nixpkgs-unstable {
      inherit (final) system;
      config.allowUnfree = true;
      overlays = [
        # overlays of unstable packages are declared here
      ];
    };
  };

  nixpkgs-overlays = _final: _prev: {
    # Your own overlays for stable nixpkgs should be declared here
  };
}
