_: {
  wayland.windowManager.hyprland.settings = {
    ###################
    ### KEYBINDINGS ###
    ###################

    # See https://wiki.hyprland.org/Configuring/Keywords/
    # Sets "Windows" key as main modifier
    "$mainMod" = "SUPER";

    bind = [
      "$mainMod, RETURN, exec, $terminal"
      "$mainMod, Q, killactive"
      "$mainMod, M, exec, command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch exit"
      "$mainMod, L, exec, hyprlock"
      "$mainMod, E, exec, $fileManager"
      "$mainMod, V, togglefloating"
      "$mainMod, SPACE, exec, $menu"
      "$mainMod, J, layoutmsg, togglesplit"
      "$mainMod, B, exec, $browser"

      # Move focus with mainMod + arrow keys
      "$mainMod, left, movefocus, l"
      "$mainMod, right, movefocus, r"
      "$mainMod, up, movefocus, u"
      "$mainMod, down, movefocus, d"

      # Swap windows with mainMod + CTRL + arrow keys
      "$mainMod CTRL, left, swapwindow, l"
      "$mainMod CTRL, right, swapwindow, r"
      "$mainMod CTRL, up, swapwindow, u"
      "$mainMod CTRL, down, swapwindow, d"

      # Switch workspaces with mainMod + [0-9]
      # Move active window to a workspace with mainMod + SHIFT + [0-9]
      "$mainMod, 1, workspace, 1"
      "$mainMod, 2, workspace, 2"
      "$mainMod, 3, workspace, 3"
      "$mainMod, 4, workspace, 4"
      "$mainMod, 5, workspace, 5"
      "$mainMod, 6, workspace, 6"
      "$mainMod, 7, workspace, 7"
      "$mainMod, 8, workspace, 8"
      "$mainMod, 9, workspace, 9"
      "$mainMod, 0, workspace, 10"
      "$mainMod SHIFT, 1, movetoworkspace, 1"
      "$mainMod SHIFT, 2, movetoworkspace, 2"
      "$mainMod SHIFT, 3, movetoworkspace, 3"
      "$mainMod SHIFT, 4, movetoworkspace, 4"
      "$mainMod SHIFT, 5, movetoworkspace, 5"
      "$mainMod SHIFT, 6, movetoworkspace, 6"
      "$mainMod SHIFT, 7, movetoworkspace, 7"
      "$mainMod SHIFT, 8, movetoworkspace, 8"
      "$mainMod SHIFT, 9, movetoworkspace, 9"
      "$mainMod SHIFT, 0, movetoworkspace, 10"

      # Scroll through existing workspaces with mainMod + scroll [e = global, m = workspace, r = workspace including empty]
      "$mainMod, mouse_down, workspace, r+1"
      "$mainMod, mouse_up, workspace, r-1"

      # Scroll through existing workspaces using mainMod + page up/down
      "$mainMod, PAGE_UP, workspace, r-1"
      "$mainMod, PAGE_DOWN, workspace, r+1"
    ];

    bindm = [
      # Move/resize windows with mainMod + LMB/RMB and dragging
      "$mainMod, mouse:272, movewindow"
      "$mainMod, mouse:273, resizewindow"
      # For touchpad ergonomics
      "$mainMod, ALT_L, resizewindow"
    ];

    bindel = [
      # Laptop multimedia keys for volume and LCD brightness
      ", XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
      ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
      ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
      ", XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
      ", XF86MonBrightnessUp, exec, brightnessctl -e4 -n2 set 5%+"
      ", XF86MonBrightnessDown, exec, brightnessctl -e4 -n2 set 5%-"
    ];

    bindl = [
      # Requires playerctl
      ", XF86AudioNext, exec, playerctl next"
      ", XF86AudioPause, exec, playerctl play-pause"
      ", XF86AudioPlay, exec, playerctl play-pause"
      ", XF86AudioPrev, exec, playerctl previous"
    ];
  };
}
