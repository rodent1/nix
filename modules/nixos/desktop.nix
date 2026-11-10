{ config, ... }:
let
  desktopHome = config.internal.homeModules.desktop;
in
{
  internal.nixosModules.default =
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
      options.modules.desktop.enable = lib.mkEnableOption "the Hyprland and Noctalia desktop session";

      config = lib.mkMerge [
        {
          assertions = [
            {
              assertion = cfg.enable -> !config.wsl.enable;
              message = "modules.desktop.enable is not supported on WSL hosts.";
            }
          ];
        }
        (lib.mkIf cfg.enable {
          # Hosts without the desktop session never import the desktop bundle,
          # so its Home Manager modules need no guard of their own.
          home-manager.users.stianrs.imports = [ desktopHome ];

          boot.loader.systemd-boot.enable = true;
          boot.loader.efi.canTouchEfiVariables = true;
          boot.kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;

          networking.networkmanager.enable = true;

          # Noctalia Greeter discovers NixOS sessions through the system profile.
          environment.systemPackages = config.services.displayManager.sessionPackages;

          programs = {
            hyprland = {
              enable = true;
              package = pkgs.unstable.hyprland;
              portalPackage = pkgs.unstable.xdg-desktop-portal-hyprland;
              withUWSM = true;
            };

            noctalia = {
              enable = true;
              recommendedServices.enable = true;
            };
          };

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

          services = {
            # Register the Secret Service and its unlock prompt with D-Bus.
            gnome.gnome-keyring.enable = true;

            displayManager = {
              noctalia-greeter = {
                enable = true;
                settings = {
                  session.default = "Hyprland (uwsm-managed)";
                  user.default = "stianrs";

                  cursor = {
                    theme = "Adwaita";
                    size = 24;
                  };

                  keyboard = {
                    layout = "no";
                    variant = "nodeadkeys";
                  };

                  idle.timeout = 300;
                };
              };
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

          console.keyMap = "no";
          security.rtkit.enable = true;
          security.pam.services.greetd.enableGnomeKeyring = true;
          security.sudo.wheelNeedsPassword = false;
        })
      ];
    };
}
