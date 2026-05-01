{
  pkgs,
  config,
  ...
}:
{
  imports = [ ./hardware-configuration.nix ];

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

    hardware.bluetooth.enable = true;
    services.fprintd.enable = true;

    modules = {
      desktop.enable = true;
      users.stianrs.hashedPasswordFile = config.services.onepassword-secrets.secretPaths.hashedPassword;
    };
  };
}
