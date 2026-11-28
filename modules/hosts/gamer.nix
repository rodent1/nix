{
  internal.hosts.gamer = {
    system = "x86_64-linux";
  };

  internal.nixosModules.gamer =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      imports = [ ./_hardware/gamer.nix ];

      config = lib.mkMerge [
        {
          hardware = {
            graphics = {
              enable = true;
              enable32Bit = true;
            };

            nvidia = {
              open = true;
              branch = "latest";

              modesetting.enable = true;
              powerManagement.enable = true;
            };
          };

          services.xserver.videoDrivers = [ "nvidia" ];

          programs.appimage = {
            enable = true;
            binfmt = true;
          };

          programs.steam.enable = true;

          services.tailscale = {
            useRoutingFeatures = "server";

            extraSetFlags = [
              "--advertise-routes=10.1.1.0/24"
              "--advertise-exit-node"
            ];
          };

          modules = {
            desktop.enable = true;
            services.tailscale.enable = true;
          };
        }

        (lib.mkIf config.modules.desktop.enable {
          services.displayManager.noctalia-greeter.settings.output.name = "DP-1";

          home-manager.users.stianrs = {
            home.packages = with pkgs; [
              nvtopPackages.nvidia
              mangohud
              unstable.rusty-path-of-building
            ];

            programs.noctalia.settings = {
              idle.behavior."lock-and-suspend" = {
                enabled = false;
                timeout = 900;
                action = "lock_and_suspend";
              };

              # DP-3 is reserved for Discord, so it gets no bar.
              bar.default.monitor.DP-3.enabled = false;
            };

            # Workspaces are per output. HDR stays off, its default.
            programs.umbriel.settings = {
              output = {
                DP-1 = {
                  mode = "2560x1440@165";
                  position = [
                    0
                    1440
                  ];
                  vrr = "fullscreen";
                  focus_at_startup = true;
                };
                DP-2 = {
                  mode = "2560x1440@144";
                  position = [
                    0
                    0
                  ];
                };
                # DP-3 is a dedicated Discord display with a single workspace.
                DP-3 = {
                  mode = "1920x1080@144";
                  position = [
                    2560
                    1189
                  ];
                  transform = "270";
                  workspaces = [ "Discord" ];
                };
              };

              workspace = [
                {
                  name = "Discord";
                  output = "DP-3";
                  layout.gap = 0;
                }
              ];

              window_rule = [
                # Umbriel has no per-workspace decoration, so Discord itself
                # goes undecorated.
                {
                  match.app_id = "^vesktop$";
                  corner_radius = 0;
                  border_width = 0;
                  shadow = false;
                }
                {
                  match.title = "^(Battle\\.net.*)$";
                  default_floating = true;
                  focus_on_activate = false;
                }
              ];
            };
          };
        })
      ];
    };
}
