{
  config,
  hostname,
  isWSL,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.modules.desktop.hyprland;
in
{
  imports = lib.optionals (!isWSL) [
    ./hostconfig/${hostname}

    ./autostart.nix
    ./env.nix
    ./hyprland.nix
    ./hyprlock.nix
    ./keybinds.nix
    ./launcher.nix
    ./rules.nix
    ./wayle.nix
  ];

  options.modules.desktop.hyprland = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Hyprland home-manager modules";
    };
  };

  config = lib.mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      enable = true;
      package = null;
      portalPackage = null;
      systemd.enable = true;
      systemd.variables = [ "--all" ];
    };

    services = {
      hyprpolkitagent.enable = true; # polkit agent for Hyprland
      cliphist.enable = true; # clipboard manager
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

    home.packages = with pkgs; [
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
      wl-clipboard
    ];
  };
}
