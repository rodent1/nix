{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.modules.desktop;
  envCfg = cfg.environments;

  needsXserver = envCfg.gnome.enable || envCfg.plasma.enable;

  portalPackages = lib.unique (
    [ pkgs.xdg-desktop-portal-gtk ]
    ++ lib.optionals envCfg.hyprland.enable [ pkgs.xdg-desktop-portal-hyprland ]
    ++ lib.optionals envCfg.gnome.enable [ pkgs.xdg-desktop-portal-gnome ]
    ++ lib.optionals envCfg.plasma.enable [ pkgs.kdePackages.xdg-desktop-portal-kde ]
  );
in
{
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

    programs.appimage = {
      enable = true;
      binfmt = true;
    };

    programs.dconf.enable = true;

    services.xserver.enable = lib.mkDefault needsXserver;
    services.displayManager.sddm = lib.mkIf (cfg.sessionManager == "sddm") {
      enable = true;
      enableHidpi = true;
      wayland.enable = true;
    };

    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    services.gvfs.enable = true;
    services.tumbler.enable = true;
    services.tuned.enable = true;
    services.upower.enable = true;
    services.gnome.gnome-keyring.enable = true;

    catppuccin.sddm = lib.mkIf (cfg.sessionManager == "sddm") {
      enable = true;
      fontSize = "36";
      flavor = "mocha";
      accent = "blue";
      userIcon = true;
    };

    xdg.portal = {
      enable = true;
      xdgOpenUsePortal = true;
      extraPortals = portalPackages;
    };

    environment.sessionVariables.NIXOS_OZONE_WL = "1";

    console.keyMap = "no";

    security.polkit.enable = true;
    security.rtkit.enable = true;
    security.pam.services.sddm.enableGnomeKeyring = true;
    security.pam.services.login.enableGnomeKeyring = true;
  };
}
