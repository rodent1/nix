# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example' or (legacy) 'nix-build -A example'
{
  pkgs ? (import <nixpkgs>) { },
  ...
}:
let
  inherit (pkgs) callPackage;
in
{
  kubecolor = callPackage ./kubecolor.nix { };
  gh-copilot = callPackage ./gh-copilot.nix { };
  gh-tidy = callPackage ./gh-tidy.nix { };
  shcopy = callPackage ./shcopy.nix { };
  tmux-fish = callPackage ./tmux-fish.nix { };
}
