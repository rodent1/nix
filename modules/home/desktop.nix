{ ... }:
{
  flake.homeModules.desktop =
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
        ./desktop/_hostconfig/${hostname}
        ./desktop/_apps
        ./desktop/_modules/autostart.nix
        ./desktop/_modules/env.nix
        ./desktop/_modules/hypridle.nix
        ./desktop/_modules/hyprland.nix
        ./desktop/_modules/hyprlock.nix
        ./desktop/_modules/keybinds.nix
        ./desktop/_modules/launcher.nix
        ./desktop/_modules/rules.nix
        ./desktop/_modules/wayle.nix
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
          hyprpolkitagent.enable = true;
          cliphist.enable = true;
        };

        catppuccin = {
          hyprland.enable = true;
          hyprtoolkit.enable = true;

          cursors = {
            enable = true;
            flavor = "latte";
            accent = "light";
          };
        };

        home.file.".face".source = ./desktop/_assets/profile.jpg;

        home.packages = with pkgs; [
          evince
          eog
          gnome-calculator
          gnome-text-editor
          nautilus
          showtime
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
    };
}
