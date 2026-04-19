{
  imports = [
    ./locale.nix
    ./nix.nix
    ./shells.nix
  ];

  programs.nix-ld.enable = true;
}
