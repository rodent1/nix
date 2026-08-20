{
  internal.hosts.gamer = {
    system = "x86_64-linux";
    isWSL = false;
  };

  internal.nixosModules.gamer = { config, ... }: {
    imports = [ ./_hardware/gamer.nix ];

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

          package = config.boot.kernelPackages.nvidiaPackages.latest;
        };
      };

      services.xserver.videoDrivers = [ "nvidia" ];

      programs.steam.enable = true;

      modules = {
        desktop.enable = true;
        desktop.plasma = true;
        services.tailscale.enable = true;
      };
    };
  };
}
