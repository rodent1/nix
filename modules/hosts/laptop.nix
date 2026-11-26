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
            programs.noctalia.settings = {
              idle.behavior."lock-and-suspend" = {
                enabled = true;
                timeout = 900;
                action = "lock_and_suspend";
              };

              brightness = {
                minimum_brightness = 0.003;
                monitor.eDP-1 = {
                  backend = "backlight";
                  backlight_device = "intel_backlight";
                };
              };
            };

            programs.umbriel.settings = {
              # Horizontal workspaces keep the three-finger swipe sideways.
              output.eDP-1 = {
                scale = 1.5;
                workspace_axis = "horizontal";
              };

              workspace = [ { name = "Discord"; } ];
            };
          };
        })
      ];
    };
}
