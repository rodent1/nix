{
  pkgs,
  ...
}:
{
  imports = [ ./hardware-configuration.nix ];

  config = {
    services.displayManager.sddm.wayland.enable = true;

    hardware = {
      graphics = {
        enable = true;
        enable32Bit = true;
        extraPackages = with pkgs; [
          libva-vdpau-driver
          nvidia-vaapi-driver
        ];
      };
    };

    services.xserver.videoDrivers = [ "nvidia" ];

    hardware.nvidia = {
      open = true;
      nvidiaSettings = true;
      modesetting.enable = true;
      powerManagement.enable = true;
    };

    modules = {
      desktop.enable = true;
      games.enable = true;
    };
  };
}
