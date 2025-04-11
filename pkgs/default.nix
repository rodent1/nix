{
  pkgs,
  ...
}:
{
  atuin = pkgs.callPackage ./atuin.nix {
    toolchain = pkgs.unstable.fenix.minimal.toolchain;
  };
  gh-copilot = pkgs.callPackage ./gh-copilot.nix { };
  gh-tidy = pkgs.callPackage ./gh-tidy.nix { };
  kubecolor-catppuccin = pkgs.callPackage ./kubecolor-catppuccin.nix { };
  talosctl = pkgs.callPackage ./talosctl.nix { };
}
