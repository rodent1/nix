# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example' or (legacy) 'nix-build -A example'
{pkgs ? (import <nixpkgs>) {}, ...} @ inputs: let
  inherit (pkgs) callPackage;
in {
  kubecolor = callPackage ./kubecolor.nix {};
  talosctl = callPackage ./talosctl.nix {};
  nvim = callPackage ./nvim.nix inputs;
  usage = callPackage ./usage.nix inputs;
}
