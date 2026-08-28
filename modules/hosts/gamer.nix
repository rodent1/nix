{
  internal.hosts.gamer = {
    system = "x86_64-linux";
    isWSL = false;
  };

  internal.nixosModules.gamer =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      imports = [ ./_hardware/gamer.nix ];

      config = {
        boot.kernelPackages = lib.mkForce pkgs.unstable.linuxPackages_latest;

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

            package = config.boot.kernelPackages.nvidiaPackages.new_feature;
          };
        };

        services.xserver.videoDrivers = [ "nvidia" ];

        programs.steam.enable = true;

        programs.noctalia-greeter.settings.output.name = "DP-1";

        modules = {
          desktop.enable = true;
          desktop.hyprland = true;
          desktop.plasma = true;
          services.tailscale.enable = true;
        };
      };
    };
}
