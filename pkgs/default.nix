{
  pkgs,
  ...
}:
{
  atuin = pkgs.callPackage ./atuin.nix { };
  gh-tidy = pkgs.callPackage ./gh-tidy.nix { };
  kubecolor-catppuccin = pkgs.callPackage ./kubecolor-catppuccin.nix { };
  talosctl = pkgs.callPackage ./talosctl.nix { };
}
