{
  config,
  lib,
  ...
}:
let
  cfg = config.modules.desktop.environments.hyprland;

  workspaceBinds = builtins.concatLists (
    builtins.genList (
      i:
      let
        ws = if i == 9 then "10" else toString (i + 1);
        key = if i == 9 then "0" else toString (i + 1);
      in
      [
        "$mainMod, ${key}, workspace, ${ws}"
        "$mainMod SHIFT, ${key}, movetoworkspace, ${ws}"
      ]
    ) 10
  );
in
{
  config = lib.mkIf cfg.enable {
    wayland.windowManager.hyprland.settings = {
      bind = [
        "$mainMod, SPACE, exec, fuzzel"
        "$mainMod, RETURN, exec, ghostty"
        "$mainMod, B, exec, firefox"
        "$mainMod, L, exec, hyprlock"
        "$mainMod, Q, killactive"
        "$mainMod SHIFT, Q, exit"
        "$mainMod, E, exec, nautilus"
        "$mainMod, V, togglefloating"
        "$mainMod, F, fullscreen, 0"
        "$mainMod, P, pseudo"
        "$mainMod, J, togglesplit"

        "$mainMod, left, movefocus, l"
        "$mainMod, right, movefocus, r"
        "$mainMod, up, movefocus, u"
        "$mainMod, down, movefocus, d"

        "$mainMod SHIFT, left, movewindow, l"
        "$mainMod SHIFT, right, movewindow, r"
        "$mainMod SHIFT, up, movewindow, u"
        "$mainMod SHIFT, down, movewindow, d"

        "$mainMod, mouse_down, workspace, e+1"
        "$mainMod, mouse_up, workspace, e-1"
      ]
      ++ workspaceBinds;

      bindm = [
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];

      bindel = [
        ", XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
        ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ", XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        ", XF86MonBrightnessUp, exec, brightnessctl -e4 -n2 set 5%+"
        ", XF86MonBrightnessDown, exec, brightnessctl -e4 -n2 set 5%-"
      ];

      bindl = [
        ", XF86AudioNext, exec, playerctl next"
        ", XF86AudioPause, exec, playerctl play-pause"
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioPrev, exec, playerctl previous"
      ];
    };
  };
}
