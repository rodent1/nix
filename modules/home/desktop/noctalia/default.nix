{
  internal.homeModules.desktop =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.modules.desktop.noctalia;
    in
    {
      options.modules.desktop.noctalia.enable = lib.mkEnableOption "Noctalia home configuration";

      config = lib.mkIf (config.modules.desktop.enable && cfg.enable && !config.host.isWSL) {
        programs.noctalia = {
          enable = true;
          systemd.enable = true;
          settings = {
            shell = {
              font_family = "Inter";
              launch_apps_as_systemd_services = true;
            };

            theme = {
              mode = "dark";
              source = "builtin";
              builtin = "Catppuccin";
            };
          };
        };

        # Start Noctalia only with Hyprland, then stop it as UWSM tears the
        # compositor session down so its surfaces cannot leak into Plasma.
        systemd.user.services.noctalia = {
          Install.WantedBy = lib.mkForce [ "hyprland-session.target" ];
          Unit = {
            After = [ "hyprland-session.target" ];
            Before = [ "wayland-session-shutdown.target" ];
            Conflicts = [ "wayland-session-shutdown.target" ];
          };
        };

        # Consume the password preserved by pam_kwallet when the Hyprland
        # graphical session starts, just as Plasma does for its own session.
        systemd.user.targets.hyprland-session.Unit.Wants = [
          "plasma-kwallet-pam.service"
          "plasma-xembedsniproxy.service"
        ];

        services = {
          cliphist.enable = true;
          hyprpolkitagent.enable = true;
        };

        home.packages = with pkgs; [
          brightnessctl
          ffmpegthumbnailer
          file-roller
          grim
          nautilus
          pavucontrol
          playerctl
          slurp
          wl-clipboard
        ];
      };
    };
}
