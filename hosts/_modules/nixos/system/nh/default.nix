{...}: {
  programs.nh = {
    enable = true;
    flake = "/home/stianrs/nix";
    clean = {
      enable = true;
      dates = "weekly";
      extraArgs = "--keep 4 --keep-since 7d";
    };
  };
}
