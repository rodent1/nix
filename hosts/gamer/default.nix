{
  pkgs,
  lib,
  config,
  hostname,
  ...
}:
{
  imports = [ ./hardware-configuration.nix ];

  config = {
    networking = {
      hostName = hostname;
    };

    services.displayManager.sddm.wayland.enable = true;

    hardware.graphics.enable = true;
    services.xserver.videoDrivers = [ "nvidia" ];

    hardware.nvidia = {
      open = false;
      nvidiaSettings = true;
      modesetting.enable = true;
      powerManagement.enable = true;

      package = lib.mkDefault config.boot.kernelPackages.nvidiaPackages.latest;
    };

    hardware.enableRedistributableFirmware = true;

    modules = {
      desktop.enable = true;
      games.enable = true;
      services.podman.enable = true;
      services.tailscale.enable = false;
      system.openssh.enable = true;
    };
  };
}
