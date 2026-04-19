{
  hostname,
  ...
}:
{
  imports = [ ./hardware-configuration.nix ];

  config = {
    networking = {
      hostName = hostname;
    };

    modules = {
      services.podman.enable = true;
      services.tailscale.enable = false;
      system.openssh.enable = true;
    };
  };

  # # Use the systemd-boot EFI boot loader.
  # boot.loader.systemd-boot.enable = true;
  # boot.loader.efi.canTouchEfiVariables = true;
}
