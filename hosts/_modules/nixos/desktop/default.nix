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

    niri = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable niri system integration";
      };

      package = lib.mkOption {
        type = lib.types.package;
        default = pkgs.unstable.niri;
        description = "niri package to install and use";
      };
    };

    hyprland = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable Hyprland system integration";
      };

      package = lib.mkOption {
        type = lib.types.package;
        default = pkgs.hyprland;
        description = "Hyprland package to install and use";
      };
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
      liberation_ttf
      monaspace
      noto-fonts
      roboto
    ];

    programs.niri = lib.mkIf cfg.niri.enable {
      enable = true;
      inherit (cfg.niri) package;
    };

    programs.hyprland = lib.mkIf cfg.hyprland.enable {
      enable = true;
      withUWSM = true;
      inherit (cfg.hyprland) package;
    };

    programs.appimage = {
      enable = true;
      binfmt = true;
    };

    environment.systemPackages = lib.optionals cfg.niri.enable (
      with pkgs;
      [
        xwayland-satellite
      ]
    );

    services = {
      displayManager.sddm = {
        enable = true;
        enableHidpi = true;
        wayland.enable = true;
      };

      pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
      };

      gvfs.enable = true;
      tumbler.enable = true;
      tuned.enable = true;
      upower.enable = true;
    };

    catppuccin.sddm = {
      enable = true;
      fontSize = "36";
      flavor = "mocha";
      accent = "blue";
      userIcon = true;
    };

    console.keyMap = "no";

    security.rtkit.enable = true;
    security.pam.services.sddm.enableGnomeKeyring = true;
    security.pam.services.login.enableGnomeKeyring = true;
    services.gnome.gnome-keyring.enable = true;
  };
}
