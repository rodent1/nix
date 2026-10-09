{
  internal.hosts.laptop = {
    system = "x86_64-linux";
    isWSL = false;
  };

  internal.nixosModules.laptop =
    { pkgs, ... }:
    {
      imports = [ ./_hardware/laptop.nix ];

      config = {
        services.xserver.videoDrivers = [ "modesetting" ];
        hardware.graphics = {
          enable = true;
          extraPackages = with pkgs; [
            intel-media-driver
            vpl-gpu-rt
          ];
        };

        environment.sessionVariables = {
          LIBVA_DRIVER_NAME = "iHD";
        };

        environment.systemPackages = with pkgs; [
          brightnessctl
          playerctl
        ];

        programs.appimage = {
          enable = true;
          binfmt = true;
        };

        hardware.bluetooth.enable = true;
        services.fprintd.enable = true;
        services.tailscale.useRoutingFeatures = "client";

        modules = {
          desktop.enable = true;
          desktop.hyprland = true;
          desktop.plasma = false;
          services.tailscale.enable = true;
        };
      };
    };
}
