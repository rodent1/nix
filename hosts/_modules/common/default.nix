{
  imports = [
    ./locale.nix
    ./nix.nix
    ./shells.nix
    ./sops.nix
  ];

  programs.nix-ld.enable = true;
}
