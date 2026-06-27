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
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable desktop module";
    };

    hyprland = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Hyprland";
    };

    plasma = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Plasma";
    };
  };

  config = lib.mkIf cfg.enable {
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
    boot.kernelPackages = pkgs.linuxPackages_latest;

    networking.networkmanager.enable = true;

    i18n.defaultLocale = "en_GB.UTF-8";
    i18n.extraLocaleSettings = {
      LC_ADDRESS = "nb_NO.UTF-8";
      LC_IDENTIFICATION = "nb_NO.UTF-8";
      LC_MEASUREMENT = "nb_NO.UTF-8";
      LC_MONETARY = "nb_NO.UTF-8";
      LC_NAME = "nb_NO.UTF-8";
      LC_NUMERIC = "nb_NO.UTF-8";
      LC_PAPER = "nb_NO.UTF-8";
      LC_TELEPHONE = "nb_NO.UTF-8";
      LC_TIME = "nb_NO.UTF-8";
    };

    fonts.enableDefaultPackages = true;
    fonts.fontconfig = {
      enable = true;
      useEmbeddedBitmaps = true;
      defaultFonts = {
        monospace = [ "Noto Mono" ];
        sansSerif = [ "Noto Sans" ];
        serif = [ "Noto Serif" ];
      };
    };
    fonts.packages = with pkgs; [
      corefonts
      fira-code
      fira-code-symbols
      font-awesome
      inter
      liberation_ttf
      material-symbols
      monaspace
      nerd-fonts.jetbrains-mono
      nerd-fonts.symbols-only
      noto-fonts
      roboto
    ];

    programs.hyprland = lib.mkIf cfg.hyprland {
      enable = true;
      package = pkgs.unstable.hyprland;
      portalPackage = pkgs.unstable.xdg-desktop-portal-hyprland;
      withUWSM = false;
    };

    services = {
      displayManager.sddm = {
        enable = true;
        enableHidpi = true;
        wayland.enable = true;
      };

      desktopManager.plasma6 = lib.mkIf cfg.plasma {
        enable = true;
      };

      pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
      };

      xserver.xkb = {
        layout = "no";
        variant = "nodeadkeys";
      };

      gvfs.enable = true;
      tumbler.enable = true;
      tuned.enable = true;
      upower.enable = true;
    };

    catppuccin.sddm = {
      enable = true;
      flavor = "mocha";
      accent = "blue";
      userIcon = true;
    };

    console.keyMap = "no";
    security.rtkit.enable = true;
    security.sudo.wheelNeedsPassword = false;

  };
}
