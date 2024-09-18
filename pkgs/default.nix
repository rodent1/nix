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
  #  kubecolor = callPackage ./kubecolor.nix { };
  gh-copilot = callPackage ./gh-copilot.nix { };
  gh-tidy = callPackage ./gh-tidy.nix { };
  talhelper = inputs.talhelper.packages.${pkgs.system}.default;
}
