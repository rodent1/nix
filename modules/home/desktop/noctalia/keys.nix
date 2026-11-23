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
      # Fragments from other modules are concatenated around this one in file
      # order, so no other fragment may read these Lua locals.
      wayland.windowManager.hyprland.extraConfig = ''
        local mainMod = "SUPER"
        local ipc = "noctalia msg "

        -- Application launchers
        hl.bind(mainMod .. "+Space", hl.dsp.exec_cmd(ipc .. "panel-toggle launcher"))
        hl.bind(mainMod .. "+Return", hl.dsp.exec_cmd("ghostty"))
        hl.bind(mainMod .. "+B", hl.dsp.exec_cmd("firefox"))
        hl.bind(mainMod .. "+CTRL + B", hl.dsp.exec_cmd("firefox --private-window"))
        hl.bind(mainMod .. "+E", hl.dsp.exec_cmd("nautilus"))
        hl.bind(mainMod .. "+SHIFT + S", hl.dsp.exec_cmd("waytator --screenshot"))

        -- Window management.
        hl.bind(mainMod .. "+Q", hl.dsp.window.close())
        hl.bind(mainMod .. "+F", hl.dsp.window.float({ action = "toggle" }))
        hl.bind(mainMod .. "+M", hl.dsp.window.fullscreen_state({ internal = 1, client = 0 }))
        hl.bind(mainMod .. "+left", hl.dsp.focus({ direction = "l" }))
        hl.bind(mainMod .. "+right", hl.dsp.focus({ direction = "r" }))
        hl.bind(mainMod .. "+up", hl.dsp.focus({ direction = "u" }))
        hl.bind(mainMod .. "+down", hl.dsp.focus({ direction = "d" }))
        hl.bind(mainMod .. "+CTRL + left", hl.dsp.window.move({ direction = "l" }))
        hl.bind(mainMod .. "+CTRL + right", hl.dsp.window.move({ direction = "r" }))
        hl.bind(mainMod .. "+CTRL + up", hl.dsp.window.move({ direction = "u" }))
        hl.bind(mainMod .. "+CTRL + down", hl.dsp.window.move({ direction = "d" }))
        hl.bind(mainMod .. "+mouse:272", hl.dsp.window.drag(), { mouse = true })
        hl.bind(mainMod .. "+mouse:273", hl.dsp.window.resize(), { mouse = true })
        hl.bind(mainMod .. "+ALT_L", hl.dsp.window.resize(), { mouse = true })

        -- Workspace management
        hl.bind(mainMod .. "+mouse_down", hl.dsp.exec_cmd(ipc .. "workspace-switch prev"))
        hl.bind(mainMod .. "+mouse_up", hl.dsp.exec_cmd(ipc .. "workspace-switch next"))
        hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })

        -- Lock screen
        hl.bind(mainMod .. "+L", hl.dsp.exec_cmd(ipc .. "session lock"))

        for i = 1, 9 do
          hl.bind(mainMod .. "+code:1" .. tostring(i - 1), hl.dsp.focus({ workspace = tostring(i) }))
          hl.bind(mainMod .. "+SHIFT+code:1" .. tostring(i - 1), hl.dsp.window.move({ workspace = tostring(i) }))
        end

        hl.bind(mainMod .. "+N", hl.dsp.exec_cmd(ipc .. "nightlight-force-toggle"))

        -- Noctalia panels
        hl.bind(mainMod .. "+S", hl.dsp.exec_cmd(ipc .. "panel-toggle control-center"))
        hl.bind(mainMod .. "+comma", hl.dsp.exec_cmd(ipc .. "settings-toggle"))
        hl.bind("ALT + Tab", hl.dsp.exec_cmd(ipc .. "window-switcher"))

        -- Media keys
        hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd(ipc .. "volume-up"))
        hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd(ipc .. "volume-down"))
        hl.bind("XF86AudioMute", hl.dsp.exec_cmd(ipc .. "volume-mute"))
        hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd(ipc .. "brightness-up"))
        hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd(ipc .. "brightness-down"))
      '';

      # Umbriel binds match the unshifted key, so Mod+Shift+1 works on the
      # Norwegian layout. Mod+left-drag moves and Mod+right-drag resizes
      # windows, and a three-finger swipe changes workspace, without binds.
      programs.umbriel.settings.keybinds =
        # Hyprland binds fire once per press; Umbriel binds repeat by default.
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
              "Mod+E" = "spawn nautilus";
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

              # Media keys
              "XF86AudioRaiseVolume" = "spawn ${ipc}volume-up";
              "XF86AudioLowerVolume" = "spawn ${ipc}volume-down";
              "XF86AudioMute" = "spawn ${ipc}volume-mute";
              "XF86MonBrightnessUp" = "spawn ${ipc}brightness-up";
              "XF86MonBrightnessDown" = "spawn ${ipc}brightness-down";
            }
            // workspaceBinds
          );
    };
}
