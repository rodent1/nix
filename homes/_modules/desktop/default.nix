{
  config,
  lib,
  isWSL,
  ...
}:
let
  cfg = config.modules.desktop;
in
{
  options.modules.desktop = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable desktop home-manager modules";
    };
  };

  imports = lib.optionals (!isWSL) [
    ./apps
    ./hyprland
    ./plasma
  ];

  config = lib.mkIf (cfg.enable && !isWSL) {
    # profile picture
    home.file.".face".source = ./assets/profile.jpg;
  };
}
