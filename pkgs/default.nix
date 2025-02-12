{
  pkgs,
  ...
}:
{
  gh-copilot = pkgs.callPackage ./gh-copilot.nix { };
  gh-tidy = pkgs.callPackage ./gh-tidy.nix { };
  kubecolor-catppuccin = pkgs.callPackage ./kubecolor-catppuccin.nix { };
  talosctl = pkgs.callPackage ./talosctl.nix { };
  usage = pkgs.callPackage ./usage.nix { };
}
