{
  imports = [
    ./users.nix
    ./services
    ./system
  ];

  networking.extraHosts = ''
    10.1.1.31 node-1
    10.1.1.32 node-2
    10.1.1.33 node-3
    10.1.1.34 node-4
    10.1.1.35 node-5
  '';

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

  boot.tmp.cleanOnBoot = true;
}
