{
  rodent.hosts.gamer = {
    system = "x86_64-linux";
    isWSL = false;
  };

  rodent.nixosModules.gamer = _: {
    imports = [ ./gamer/_hardware/default.nix ];

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
        desktop.plasma = true;
      };
    };
  };
}
