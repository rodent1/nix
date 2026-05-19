{
  flake.modules.nixos.security = {
    security = {
      pam.sshAgentAuth.enable = true;
      rtkit.enable = true;

      sudo = {
        enable = true;
        wheelNeedsPassword = false;
      };
    };
  };
}
