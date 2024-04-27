{
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./nix.nix
    ./users.nix
    ./services
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

  system = {
    # Enable printing changes on nix build etc with nvd
    activationScripts.report-changes = ''
      PATH=$PATH:${lib.makeBinPath [pkgs.nvd pkgs.nix]}
      nvd diff $(ls -dv /nix/var/nix/profiles/system-*-link | tail -2)
    '';

    # Do not change unless you know what you are doing
    stateVersion = "23.11";
  };
}
