{ ... }:
{
  imports = [
    ./users.nix

    ./security
    ./services
    ./system
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
    # Do not change unless you know what you are doing
    stateVersion = "24.05";
  };
}
