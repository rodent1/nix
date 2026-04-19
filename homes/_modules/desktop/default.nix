{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.modules.desktop;
in
{
  imports = [
    ./hyprland
  ];

  options.modules.desktop = {
    enable = lib.mkEnableOption "desktop applications";
  };

  config = lib.mkIf cfg.enable {
    programs = {
      discord.enable = true;
      firefox.enable = true;

      ghostty = {
        enable = true;
        enableFishIntegration = true;
        settings = {
          link-url = true;

          window-width = 160;
          window-height = 50;
        };
      };

      vscode = {
        enable = true;
        package = pkgs.unstable.vscode;
      };
    };
  };
}
