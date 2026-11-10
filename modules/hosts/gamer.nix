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
          boot.kernelPackages = lib.mkForce pkgs.unstable.linuxPackages_latest;

          hardware = {
            graphics = {
              enable = true;
              enable32Bit = true;
            };

            nvidia = {
              open = true;
              branch = "stable";

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

            # Monitor layout and host rules come before the shared session config.
            wayland.windowManager.hyprland.extraConfig = lib.mkBefore ''
              hl.monitor({ output = "DP-1", cm = "auto", mode = "highrr", position = "0x1440", scale = 1, vrr = 3})
              hl.monitor({ output = "DP-2", cm = "auto", mode = "highrr", position = "0x0", scale = 1 })
              hl.monitor({ output = "DP-3", cm = "auto", mode = "highrr", position = "2560x1189", scale = 1, transform = 3 })
              hl.monitor({ output = "", mode = "preferred", position = "auto", scale = 1 })
              -- Avoid fullscreen HDR mode switches that cause flashing and incorrect colors.
              hl.config({ render = { cm_auto_hdr = 0 } })

              -- DP-2 is the top monitor
              hl.workspace_rule({
                workspace = "name:Top",
                monitor = "DP-2",
                default = true,
                persistent = true,
              })

              -- DP-3 is a dedicated, undecorated Discord display.
              hl.workspace_rule({
                workspace = "name:Discord",
                monitor = "DP-3",
                default = true,
                persistent = true,
                gaps_in = 0,
                gaps_out = 0,
                no_rounding = true,
                no_border = true,
                decorate = false,
              })

              -- Window rules
              hl.window_rule({
                match = { title = "^(Battle.net.*)$" },
                float = true,
                focus_on_activate = false,
              })
            '';
          };
        })
      ];
    };
}
