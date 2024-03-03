# This file defines overlays
{inputs, ...}: {
  # This one brings our custom packages from the 'pkgs' directory
  additions = final: _prev: import ../pkgs {pkgs = final;};

  # This one contains whatever you want to overlay
  # You can change versions, add patches, set compilation flags, anything really.
  # https://nixos.wiki/wiki/Overlays
  modifications = final: prev: {
    # example = prev.example.overrideAttrs (oldAttrs: rec {
    # ...
    # });
    # kubecolor = prev.kubecolor.overrideAttrs (oldAttrs: {
    #   version = "v0.0.25";
    #   src = prev.fetchFromGitHub {
    #     owner = "hidetatz";
    #     repo = "kubecolor";
    #     rev = "2ce3b8b099a44b6f0d0d0b62ae228a65c437e6a5";
    #     # obtained from `nix-shell -p nix-prefetch-github --run "nix-prefetch-github hidetatz kubecolor --rev v0.0.25"`
    #     hash = "sha256-FyKTI7Br9BjSpmf9ch2E4EZAWM7/jowZfRrCn4GTcps=";
    #   };
    #   buildInputs = oldAttrs.buildInputs or [] ++ [final.unstable.go];
    # });

  };

  # When applied, the unstable nixpkgs set (declared in the flake inputs) will
  # be accessible through 'pkgs.unstable'
  unstable-packages = final: _prev: {
    unstable = import inputs.nixpkgs-unstable {
      system = final.system;
      config.allowUnfree = true;
    };
  };
}
