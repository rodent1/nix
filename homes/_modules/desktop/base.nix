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
  config = lib.mkIf cfg.enable {
    programs = {
      firefox.enable = true;

      vesktop = {
        enable = true;
        settings = {
          minimizeToTray = true;
          arRPC = true;
        };

        vencord.settings = {
          frameless = true;
        };
      };

      ghostty = {
        enable = true;
        enableFishIntegration = true;

        settings = {
          confirm-close-surface = false;
          link-url = true;
          window-decoration = "none";

          keybind = [
            "ctrl+v=paste_from_clipboard"
          ];
        };
      };

      vscode = {
        enable = true;
        package = pkgs.unstable.vscode;
      };
    };

    modules.themes.catppuccin.cursors = {
      enable = true;
      flavor = "latte";
      accent = "light";
    };

    home.packages = with pkgs; [
      cliphist
      ffmpegthumbnailer
      unzip
      wl-clipboard
    ];
  };
}
