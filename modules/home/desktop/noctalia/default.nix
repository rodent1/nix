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
              polkit_agent = true;
              launch_apps_as_systemd_services = true;
            };

            location.address = "Forsand, Sandnes";

            idle.behavior = {
              lock = {
                enabled = true;
                timeout = 300;
                action = "lock";
              };
              "screen-off" = {
                enabled = true;
                timeout = 330;
                action = "screen_off";
              };
              "lock-and-suspend" = {
                enabled = true;
                timeout = 900;
                action = "lock_and_suspend";
              };
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
          ffmpegthumbnailer
          file-roller
          grim
          pavucontrol
          playerctl
          slurp
          wl-clipboard
        ];
      };
    };
}
