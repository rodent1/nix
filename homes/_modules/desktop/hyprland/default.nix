{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.modules.desktop;
in
{
  options.modules.desktop.hyprland = {
    enable = lib.mkEnableOption "Hyprland desktop environment";
  };

  config = lib.mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      enable = true;
      systemd.enable = false; # Managed by UWSM in the NixOS module

      settings = {
        exec-once = [ "${pkgs.waybar}/bin/waybar" ];

        monitor = [
          "eDP-1,preferred,auto,auto"
        ];

        input = {
          kb_layout = "no";
          kb_variant = "nodeadkeys";
        };
      };

      extraConfig = "
      # See https://wiki.hypr.land/Configuring/Keywords/
      $mainMod = SUPER # Sets Windows key as main modifier

      # Example binds, see https://wiki.hypr.land/Configuring/Binds/ for more
      bind = $mainMod, Q, exec, kitty
      bind = $mainMod, F, exec, firefox
      bind = $mainMod, C, killactive,
      bind = $mainMod, M, exec, command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch exit
      bind = $mainMod, E, exec, $fileManager
      bind = $mainMod, V, togglefloating,
      bind = $mainMod, R, exec, $menu
      bind = $mainMod, P, pseudo, # dwindle
      bind = $mainMod, J, layoutmsg, togglesplit # dwindle

      # Move focus with mainMod + arrow keys
      bind = $mainMod, left, movefocus, l
      bind = $mainMod, right, movefocus, r
      bind = $mainMod, up, movefocus, u
      bind = $mainMod, down, movefocus, d

      # Switch workspaces with mainMod + [0-9]
      bind = $mainMod, 1, workspace, 1
      bind = $mainMod, 2, workspace, 2
      bind = $mainMod, 3, workspace, 3
      bind = $mainMod, 4, workspace, 4
      bind = $mainMod, 5, workspace, 5
      bind = $mainMod, 6, workspace, 6
      bind = $mainMod, 7, workspace, 7
      bind = $mainMod, 8, workspace, 8
      bind = $mainMod, 9, workspace, 9
      bind = $mainMod, 0, workspace, 10

      # Move active window to a workspace with mainMod + SHIFT + [0-9]
      bind = $mainMod SHIFT, 1, movetoworkspace, 1
      bind = $mainMod SHIFT, 2, movetoworkspace, 2
      bind = $mainMod SHIFT, 3, movetoworkspace, 3
      bind = $mainMod SHIFT, 4, movetoworkspace, 4
      bind = $mainMod SHIFT, 5, movetoworkspace, 5
      bind = $mainMod SHIFT, 6, movetoworkspace, 6
      bind = $mainMod SHIFT, 7, movetoworkspace, 7
      bind = $mainMod SHIFT, 8, movetoworkspace, 8
      bind = $mainMod SHIFT, 9, movetoworkspace, 9
      bind = $mainMod SHIFT, 0, movetoworkspace, 10
      ";
    };

    programs.waybar.enable = true;
  };
}
