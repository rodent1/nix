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
          systemd.enable = false;
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

        services = {
          cliphist.enable = true;
          gnome-keyring.enable = true;
          xembed-sni-proxy.enable = true;
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
