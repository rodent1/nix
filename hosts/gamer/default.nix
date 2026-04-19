{
  lib,
  config,
  ...
}:
{
  imports = [ ./hardware-configuration.nix ];

  config = {
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
    };
  };
}
