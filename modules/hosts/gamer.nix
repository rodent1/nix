{
  internal.hosts.gamer = {
    system = "x86_64-linux";
    isWSL = false;
  };

  internal.nixosModules.gamer =
    { lib, pkgs, ... }:
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
            branch = "stable";

            modesetting.enable = true;
            powerManagement.enable = true;
          };
        };

        services.xserver.videoDrivers = [ "nvidia" ];

        programs.appimage = {
          enable = true;
          binfmt = true;
        };

        programs.steam.enable = true;

        services.displayManager.noctalia-greeter.settings.output.name = "DP-1";
        services.tailscale = {
          useRoutingFeatures = "server";

          extraSetFlags = [
            "--advertise-routes=10.1.1.0/24"
            "--advertise-exit-node"
          ];
        };

        modules = {
          desktop.enable = true;
          desktop.hyprland = true;
          desktop.plasma = false;
          services.tailscale.enable = true;
        };
      };
    };
}
