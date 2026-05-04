{
  config,
  isWSL,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.modules.desktop;
in
{
  imports = lib.optional (!isWSL) ./niri;

  options.modules.desktop = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable desktop home-manager modules";
    };
  };

  config = lib.mkIf cfg.enable {
    programs = {
      firefox.enable = true;
      fuzzel.enable = true;
      swaylock.enable = true;
      vesktop.enable = true;

      ghostty = {
        enable = true;
        settings = {
          confirm-close-surface = false;
          link-url = true;
          maximize = true;
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

    services = {
      mako.enable = true; # notification daemon
      swayidle.enable = true; # idle management daemon
    };

    home.packages = with pkgs; [
      evince
      eog
      ffmpegthumbnailer
      file-roller
      gnome-calculator
      gnome-text-editor
      nautilus
      showtime
      unzip
    ];
  };
}
