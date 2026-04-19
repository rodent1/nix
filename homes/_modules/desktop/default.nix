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
  options.modules.desktop = {
    enable = lib.mkEnableOption "desktop applications";
  };
  config = lib.mkIf cfg.enable {
    programs = {
      discord = {
        enable = true;
      };

      firefox = {
        enable = true;
      };

      ghostty = {
        enable = true;
      };

      vscode = {
        enable = true;
        package = pkgs.unstable.vscode;
      };
    };
  };
}
