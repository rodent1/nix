{
  internal.homeModules.desktop =
    { lib, ... }:
    let
      ipc = "noctalia msg ";

      workspaceBinds = lib.mergeAttrsList (
        map (i: {
          "Mod+${i}" = "workspace-switch ${i}";
          "Mod+Shift+${i}" = "window-move-to-workspace ${i}";
        }) (map toString (lib.range 1 9))
      );
    in
    {
      # Binds match the unshifted key, so Mod+Shift+1 works on the Norwegian
      # layout. Mod+left-drag moves and Mod+right-drag resizes windows, and a
      # three-finger swipe changes workspace, without binds.
      programs.umbriel.settings.keybinds =
        # Umbriel binds repeat while held unless told otherwise.
        lib.mapAttrs
          (_: action: {
            inherit action;
            repeat = false;
          })
          (
            {
              # Application launchers
              "Mod+Space" = "spawn ${ipc}panel-toggle launcher";
              "Mod+Return" = "spawn ghostty";
              "Mod+B" = "spawn firefox";
              "Mod+Ctrl+B" = "spawn firefox --private-window";
              "Mod+E" = "spawn luciole";
              "Mod+Shift+S" = "spawn waytator --screenshot";

              # Window management
              "Mod+Q" = "window-close";
              "Mod+F" = "window-toggle-floating";
              "Mod+M" = "window-toggle-maximize";
              "Mod+Left" = "window-focus-left";
              "Mod+Right" = "window-focus-right";
              "Mod+Up" = "window-focus-up";
              "Mod+Down" = "window-focus-down";
              "Mod+Ctrl+Left" = "window-move-left";
              "Mod+Ctrl+Right" = "window-move-right";
              "Mod+Ctrl+Up" = "window-move-up";
              "Mod+Ctrl+Down" = "window-move-down";

              # Workspace management
              "Mod+WheelDown" = "workspace-previous";
              "Mod+WheelUp" = "workspace-next";

              # Lock screen
              "Mod+L" = "spawn ${ipc}session lock";

              "Mod+N" = "spawn ${ipc}nightlight-force-toggle";

              # Noctalia panels
              "Mod+S" = "spawn ${ipc}panel-toggle control-center";
              "Mod+Comma" = "spawn ${ipc}settings-toggle";
              "Alt+Tab" = "spawn ${ipc}window-switcher";
            }
            // workspaceBinds
          )
        # Media keys stay available on the lock screen, and volume and
        # brightness keep stepping while held.
        // lib.mapAttrs (_: bind: bind // { allow_when_locked = true; }) {
          "XF86AudioRaiseVolume".action = "spawn ${ipc}volume-up";
          "XF86AudioLowerVolume".action = "spawn ${ipc}volume-down";
          "XF86AudioMute" = {
            action = "spawn ${ipc}volume-mute";
            repeat = false;
          };
          "XF86MonBrightnessUp".action = "spawn ${ipc}brightness-up";
          "XF86MonBrightnessDown".action = "spawn ${ipc}brightness-down";
        };
    };
}
