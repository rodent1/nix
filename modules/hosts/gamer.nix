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
            branch = "latest";

            modesetting.enable = true;
            powerManagement.enable = true;
          };
        };

        services.xserver.videoDrivers = [ "nvidia" ];

        programs.steam.enable = true;

        programs.noctalia-greeter.settings.output.name = "DP-1";

        modules = {
          desktop.enable = true;
          desktop.hyprland = true;
          desktop.plasma = false;
          services.tailscale.enable = false;
        };
      };
    };
}
