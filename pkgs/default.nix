# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example' or (legacy) 'nix-build -A example'
{
  inputs,
  pkgs ? (import <nixpkgs>) { },
  ...
}:
let
  inherit (pkgs) callPackage;
in
{
  kubecolor-catppuccin = callPackage ./kubecolor-catppuccin.nix { };
  gh-copilot = callPackage ./gh-copilot.nix { };
  gh-tidy = callPackage ./gh-tidy.nix { };
  talhelper = inputs.talhelper.packages.${pkgs.system}.default;
  talosctl = pkgs.callPackage ./talosctl.nix { };
  fish-plugins = pkgs.fishPlugins.callPackage ./fish-plugins.nix { };
  tmux-plugins = callPackage ./tmux-plugins.nix { };
}
