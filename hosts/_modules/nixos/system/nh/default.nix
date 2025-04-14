_:
{
  programs.nh = {
    enable = true;
    flake = "/home/stianrs/nix";
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 3";
  };
}
