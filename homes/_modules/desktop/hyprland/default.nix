{
  config,
  hostname,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.modules.desktop.environments.hyprland;
  hostConfig = ./hosts + "/${hostname}.nix";
in
{
  imports = [
    ./keybinds.nix
    ./waybar.nix
  ]
  ++ lib.optional (builtins.pathExists hostConfig) hostConfig;

  options.modules.desktop.environments.hyprland = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Hyprland compositor configuration";
    };

    settings = lib.mkOption {
      type = lib.types.attrs;
      default = { };
      description = "Additional wayland.windowManager.hyprland.settings merged per host";
    };

    workspaceRules = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      example = [
        "w[tv1], gapsout:0, gapsin:0"
        "f[1], gapsout:0, gapsin:0"
      ];
      description = "Workspace rules emitted as wayland.windowManager.hyprland.settings.workspace";
    };

    extraConfig = lib.mkOption {
      type = lib.types.lines;
      default = "";
      description = "Additional raw Hyprland config merged per host";
    };
  };

  config = lib.mkIf (config.modules.desktop.enable && cfg.enable) {
    home.packages = with pkgs; [
      grim
      hyprmod
      hyprlock
      slurp
    ];

    programs = {
      hyprlock.enable = true;
    };

    wayland.windowManager.hyprland = {
      enable = true;
      package = null;
      portalPackage = null;
      systemd.enable = true;
      xwayland.enable = true;

      settings = lib.mkMerge [
        {
          "$terminal" = "ghostty";
          "$fileManager" = "nautilus";
          "$menu" = "fuzzel";
          "$browser" = "firefox";
          "$mainMod" = "SUPER";

          # Upstream example default; host modules can override this.
          monitor = lib.mkDefault [ ",preferred,auto,auto" ];

          env = [
            "XCURSOR_SIZE,24"
            "HYPRCURSOR_SIZE,24"
          ];

          input = {
            kb_layout = "no";
            kb_variant = "nodeadkeys";
            follow_mouse = 1;
            sensitivity = 0;

            touchpad = {
              natural_scroll = true;
              tap-to-click = true;
            };
          };

          gesture = [ "3, horizontal, workspace" ];

          general = {
            gaps_in = 5;
            gaps_out = 20;
            border_size = 2;

            "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
            "col.inactive_border" = "rgba(595959aa)";

            resize_on_border = false;
            allow_tearing = false;
            layout = "dwindle";
          };

          decoration = {
            rounding = 10;
            rounding_power = 2;

            active_opacity = 1.0;
            inactive_opacity = 1.0;

            shadow = {
              enabled = true;
              range = 4;
              render_power = 3;
              color = "rgba(1a1a1aee)";
            };

            blur = {
              enabled = true;
              size = 3;
              passes = 1;
              vibrancy = 0.1696;
            };
          };

          animations = {
            enabled = true;
            bezier = [
              "easeOutQuint,   0.23, 1,    0.32, 1"
              "easeInOutCubic, 0.65, 0.05, 0.36, 1"
              "linear,         0,    0,    1,    1"
              "almostLinear,   0.5,  0.5,  0.75, 1"
              "quick,          0.15, 0,    0.1,  1"
            ];

            animation = [
              "global,        1, 10,   default"
              "border,        1, 5.39, easeOutQuint"
              "windows,       1, 4.79, easeOutQuint"
              "windowsIn,     1, 4.1,  easeOutQuint, popin 87%"
              "windowsOut,    1, 1.49, linear,       popin 87%"
              "fadeIn,        1, 1.73, almostLinear"
              "fadeOut,       1, 1.46, almostLinear"
              "fade,          1, 3.03, quick"
              "layers,        1, 3.81, easeOutQuint"
              "layersIn,      1, 4,    easeOutQuint, fade"
              "layersOut,     1, 1.5,  linear,       fade"
              "fadeLayersIn,  1, 1.79, almostLinear"
              "fadeLayersOut, 1, 1.39, almostLinear"
              "workspaces,    1, 1.94, almostLinear, fade"
              "workspacesIn,  1, 1.21, almostLinear, fade"
              "workspacesOut, 1, 1.94, almostLinear, fade"
              "zoomFactor,    1, 7,    quick"
            ];
          };

          dwindle = {
            pseudotile = true;
            preserve_split = true;
          };

          master = {
            new_status = "master";
          };

          misc = {
            force_default_wallpaper = -1;
            disable_hyprland_logo = false;
          };
        }
        (lib.optionalAttrs (cfg.workspaceRules != [ ]) {
          workspace = cfg.workspaceRules;
        })
        cfg.settings
      ];

      extraConfig = ''
        # Optional permission examples (require restart):
        # permission = /usr/(bin|local/bin)/grim, screencopy, allow
        # permission = /usr/(lib|libexec|lib64)/xdg-desktop-portal-hyprland, screencopy, allow
      ''
      + cfg.extraConfig;
    };
  };
}
