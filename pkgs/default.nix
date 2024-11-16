{
  inputs,
  system,
  pkgs,
}:
{
  gh-copilot = pkgs.callPackage ./gh-copilot.nix { };
  gh-tidy = pkgs.callPackage ./gh-tidy.nix { };
  kubecolor-catppuccin = pkgs.callPackage ./kubecolor-catppuccin.nix { };
  minijinja = pkgs.callPackage ./minijinja.nix { };
  talhelper = inputs.talhelper.packages.${system}.default;
  talosctl = pkgs.callPackage ./talosctl.nix { };
}
