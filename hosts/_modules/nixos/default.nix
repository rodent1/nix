{
  lib,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./nix.nix
    ./users.nix
    "${inputs.nixpkgs-unstable}/nixos/modules/programs/nh.nix"
  ];

  documentation.nixos.enable = false;

  # Increase open file limit for sudoers
  security.pam.loginLimits = [
    {
      domain = "@wheel";
      item = "nofile";
      type = "soft";
      value = "524288";
    }
    {
      domain = "@wheel";
      item = "nofile";
      type = "hard";
      value = "1048576";
    }
  ];

  programs.nh = {
    enable = true;
    package = pkgs.unstable.nh;
    # TODO: Make this dynamic
    flake = "/home/stianrs/nix";
    clean = {
      enable = true;
      dates = "weekly";
      extraArgs = "--keep 4 --keep-since 7d";
    };
  };

  system = {
    # Do not change unless you know what you are doing
    stateVersion = "23.11";
  };
}
