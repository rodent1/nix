{
  internal.homeModules.desktop =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.modules.desktop.hyprland;
    in
    {
      options.modules.desktop.hyprland.enable =
        lib.mkEnableOption "Hyprland and Noctalia home configuration";

      config = lib.mkIf (config.modules.desktop.enable && cfg.enable && !config.host.isWSL) {
        wayland.windowManager.hyprland = {
          enable = true;
          package = null;
          portalPackage = null;

          extraConfig = ''
            local mainMod = "SUPER"
            local ipc = "noctalia msg "

            hl.config({
              general = {
                gaps_in = 5,
                gaps_out = 10,
                border_size = 2,
                layout = "dwindle",
              },

              decoration = {
                rounding = 20,
                rounding_power = 2,
                shadow = {
                  enabled = true,
                  range = 4,
                  render_power = 3,
                  color = 0xee1a1a1a,
                },
                blur = {
                  enabled = true,
                  size = 3,
                  passes = 2,
                  vibrancy = 0.1696,
                },
              },

              input = {
                kb_layout = "no",
                kb_variant = "nodeadkeys",
                follow_mouse = 1,
                touchpad = {
                  natural_scroll = true,
                },
              },

              dwindle = {
                preserve_split = true,
              },

              misc = {
                disable_hyprland_logo = true,
                focus_on_activate = true,
              },
            })

            -- Keep Noctalia's workspace indicator populated when workspaces are empty.
            for i = 1, 10 do
              hl.workspace_rule({ workspace = tostring(i), persistent = true })
            end

            -- Application launchers recovered from the previous Hyprland configuration.
            hl.bind(mainMod .. "+Return", hl.dsp.exec_cmd("ghostty"))
            hl.bind(mainMod .. "+B", hl.dsp.exec_cmd("google-chrome-stable"))
            hl.bind(mainMod .. "+Space", hl.dsp.exec_cmd(ipc .. "panel-toggle launcher"))
            hl.bind(mainMod .. "+E", hl.dsp.exec_cmd("nautilus"))

            -- Window management.
            hl.bind(mainMod .. "+Q", hl.dsp.window.close())
            hl.bind(mainMod .. "+F", hl.dsp.window.float({ action = "toggle" }))
            hl.bind(mainMod .. "+M", hl.dsp.window.fullscreen_state({ internal = 1, client = 0 }))
            hl.bind(mainMod .. "+left", hl.dsp.focus({ direction = "l" }))
            hl.bind(mainMod .. "+right", hl.dsp.focus({ direction = "r" }))
            hl.bind(mainMod .. "+up", hl.dsp.focus({ direction = "u" }))
            hl.bind(mainMod .. "+down", hl.dsp.focus({ direction = "d" }))
            hl.bind(mainMod .. "+mouse:272", hl.dsp.window.drag())
            hl.bind(mainMod .. "+mouse:273", hl.dsp.window.resize())

            for i = 1, 9 do
              hl.bind(mainMod .. "+code:1" .. tostring(i - 1), hl.dsp.focus({ workspace = tostring(i) }))
              hl.bind(mainMod .. "+SHIFT+code:1" .. tostring(i - 1), hl.dsp.window.move({ workspace = tostring(i) }))
            end

            -- Noctalia v5 panels and hardware controls.
            hl.bind(mainMod .. "+S", hl.dsp.exec_cmd(ipc .. "panel-toggle control-center"))
            hl.bind(mainMod .. "+comma", hl.dsp.exec_cmd(ipc .. "settings-toggle"))
            hl.bind("ALT+Tab", hl.dsp.exec_cmd(ipc .. "window-switcher"))
            hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd(ipc .. "volume-up"), { locked = true, repeating = true })
            hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd(ipc .. "volume-down"), { locked = true, repeating = true })
            hl.bind("XF86AudioMute", hl.dsp.exec_cmd(ipc .. "volume-mute"), { locked = true })

            hl.window_rule({
              match = { class = "dev.noctalia.Noctalia" },
              float = true,
              size = { 1080, 920 },
            })

            hl.layer_rule({
              name = "noctalia",
              match = {
                namespace = "^noctalia-(bar-.+|notification|dock|panel|attached-panel|osd|window-switcher)$",
              },
              no_anim = true,
              ignore_alpha = 0.5,
              blur = true,
              blur_popups = true,
            })
          '';
        };

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
        systemd.user.targets.hyprland-session.Unit.Wants = [ "plasma-kwallet-pam.service" ];

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
