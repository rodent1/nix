{
  internal.hosts.laptop = {
    system = "x86_64-linux";
  };

  internal.nixosModules.laptop =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      imports = [ ./_hardware/laptop.nix ];

      config = lib.mkMerge [
        {
          services.xserver.videoDrivers = [ "modesetting" ];
          hardware.graphics = {
            enable = true;
            extraPackages = with pkgs; [
              intel-media-driver
              vpl-gpu-rt
            ];
          };

          environment.sessionVariables = {
            LIBVA_DRIVER_NAME = "iHD";
          };

          environment.systemPackages = with pkgs; [
            brightnessctl
            playerctl
          ];

          programs.appimage = {
            enable = true;
            binfmt = true;
          };

          services.automatic-timezoned.enable = true;
          hardware.bluetooth.enable = true;
          services.fprintd.enable = true;
          services.tailscale.useRoutingFeatures = "client";

          modules = {
            desktop.enable = true;
            services.tailscale.enable = true;
          };
        }

        (lib.mkIf config.modules.desktop.enable {
          home-manager.users.stianrs = {
            home.packages = [ pkgs.ddcutil ];

            programs.noctalia.settings = {
              idle.behavior."lock-and-suspend" = {
                enabled = true;
                timeout = 900;
                action = "lock_and_suspend";
              };

              brightness = {
                minimum_brightness = 0.01;
                monitor.eDP-1 = {
                  backend = "backlight";
                  backlight_device = "intel_backlight";
                };
              };
            };

            # Monitor layout and host rules come before the shared session config.
            wayland.windowManager.hyprland.extraConfig = lib.mkBefore ''
              hl.monitor({ output = "eDP-1", cm = "auto", scale = 1.5 })
              -- Avoid fullscreen HDR mode switches that cause flashing and incorrect colors.
              hl.config({ render = { cm_auto_hdr = 0 } })

              hl.workspace_rule({
                workspace = "name:Discord",
                persistent = true,
              })
            '';
          };
        })
      ];
    };
}
