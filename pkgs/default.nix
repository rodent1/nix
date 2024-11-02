{
  inputs,
  system,
  pkgs,
}:
{
  kubecolor-catppuccin = pkgs.callPackage ./kubecolor-catppuccin.nix { };
  gh-copilot = pkgs.callPackage ./gh-copilot.nix { };
  gh-tidy = pkgs.callPackage ./gh-tidy.nix { };
  minijinja = pkgs.callPackage ./minijinja.nix { };
  talhelper = inputs.talhelper.packages.${system}.default;
  talosctl = pkgs.callPackage ./talosctl.nix { };
}
