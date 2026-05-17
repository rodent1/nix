_: {
  imports = [ ./hardware-configuration.nix ];

  config = {
    hardware = {
      graphics = {
        enable = true;
        enable32Bit = true;
      };

      nvidia = {
        open = true;
        nvidiaSettings = true;
        modesetting.enable = true;
        powerManagement.enable = true;
      };
    };

    services.xserver.videoDrivers = [ "nvidia" ];

    programs.steam.enable = true;

    modules = {
      desktop.enable = true;
    };
  };
}
