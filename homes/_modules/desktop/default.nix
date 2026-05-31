{
  config,
  hostname,
  isWSL,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.modules.desktop;
in
{
  imports = lib.optionals (!isWSL) [
    ./hostconfig/${hostname}
    ./apps

    ./env.nix
    ./hypridle.nix
    ./hyprland.nix
    ./hyprlock.nix
    ./keybinds.nix
    ./launcher.nix
    ./rules.nix
    ./startup.nix
    ./wayle.nix
  ];

  options.modules.desktop = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable desktop home-manager modules";
    };
  };

  config = lib.mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      enable = true;
      package = null;
      portalPackage = null;
      systemd.enable = false;
      systemd.variables = [ "--all" ];
    };

    services = {
      hyprpolkitagent.enable = true; # polkit agent for Hyprland
    };

    # Theming
    catppuccin = {
      hyprland.enable = true;
      hyprtoolkit.enable = true;

      cursors = {
        enable = true;
        flavor = "latte";
        accent = "light";
      };
    };

    # profile picture
    home.file.".face".source = ./assets/profile.jpg;

    home.packages = with pkgs; [
      # Clipboard
      cliphist
      wl-clipboard
      # Desktop apps
      evince
      eog
      gnome-calculator
      gnome-text-editor
      nautilus
      showtime
      # Utilities
      brightnessctl
      ffmpegthumbnailer
      file-roller
      grim
      hyprshutdown
      pavucontrol
      playerctl
      slurp
      unzip
    ];
  };
}
