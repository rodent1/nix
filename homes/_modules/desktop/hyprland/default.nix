{
  config,
  hostname,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.modules.desktop.hyprland;
  hostConfig = ./hosts + "/${hostname}.nix";
in
{
  imports = [
    ./keybinds.nix
  ]
  ++ lib.optional (builtins.pathExists hostConfig) hostConfig;

  options.modules.desktop.hyprland = {
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

    extraConfig = lib.mkOption {
      type = lib.types.lines;
      default = "";
      description = "Additional raw Hyprland config merged per host";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      grim
      hyprmod
      hyprlock
      slurp
      waybar
      wl-clipboard
    ];

    programs = {
      kitty.enable = true;
      waybar.enable = true;
      hyprlock.enable = true;
    };

    wayland.windowManager.hyprland = {
      enable = true;
      package = pkgs.hyprland;
      systemd.enable = true;
      xwayland.enable = true;

      settings = lib.mkMerge [
        {
          "$mainMod" = "SUPER";

          exec-once = [
            "waybar"
          ];

          input = {
            kb_layout = "no";
            kb_variant = "nodeadkeys";
            follow_mouse = 1;

            touchpad = {
              natural_scroll = true;
              tap-to-click = true;
            };
          };

          general = {
            gaps_in = 4;
            gaps_out = 8;
            border_size = 2;
            resize_on_border = false;
            allow_tearing = false;
            layout = "dwindle";
          };

          decoration = {
            rounding = 8;

            blur = {
              enabled = false;
            };
          };

          animations = {
            enabled = true;
          };

          dwindle = {
            pseudotile = true;
            preserve_split = true;
          };

          misc = {
            force_default_wallpaper = -1;
            disable_hyprland_logo = true;
            disable_splash_rendering = true;
          };

          windowrulev2 = [
            "suppressevent maximize, class:.*"
            "nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0"
          ];
        }
        cfg.settings
      ];

      inherit (cfg) extraConfig;
    };
  };
}
