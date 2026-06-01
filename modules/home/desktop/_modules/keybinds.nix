{ pkgs, lib, ... }:
let
  mkBind = key: dispatcher: opts: {
    _args = [
      (lib.generators.mkLuaInline key)
      (lib.generators.mkLuaInline dispatcher)
    ]
    ++ lib.optional (opts != { }) opts;
  };

  mkExec =
    key: cmd: desc:
    mkBind key "hl.dsp.exec_cmd([[${cmd}]])" { description = desc; };

  mkExecLocked =
    key: cmd: desc:
    mkBind key "hl.dsp.exec_cmd([[${cmd}]])" {
      description = desc;
      locked = true;
    };

  mkExecRepeatLocked =
    key: cmd: desc:
    mkBind key "hl.dsp.exec_cmd([[${cmd}]])" {
      description = desc;
      locked = true;
      repeating = true;
    };

  terminal = "ghostty";
  fileManager = "nautilus";
  menu = "fuzzel";
  browser = "firefox";
  browserPrivate = "firefox --private-window";
in
{
  config = {
    wayland.windowManager.hyprland.settings = {
      mod._var = "SUPER";

      bind = [
        (mkExec ''mod .." + M"'' "uwsm-app -- hyprshutdown -t 'Logging out...'" "Logout")
        (mkExec ''mod .." + L"'' "hyprlock" "Lock screen")
        (mkExec ''mod .." + RETURN"'' terminal "Launch terminal")
        (mkExec ''mod .." + E"'' fileManager "Launch file manager")
        (mkExec ''mod .." + B"'' browser "Launch web browser")
        (mkExec ''mod .." + SHIFT + B"'' browserPrivate "Launch private browser")
        (mkExec ''mod .." + SPACE"'' menu "Launch application menu")
        (mkBind ''mod .." + Q"'' "hl.dsp.window.close()" { description = "Close focused window"; })
        (mkBind ''mod .." + F"'' "hl.dsp.window.float({ action = \"toggle\"})" {
          description = "Toggle floating/tiled for focused window";
        })
        (mkBind ''mod .." + J"'' "hl.dsp.window.pseudo({action = \"toggle\"})" {
          description = "Toggle split/unsplit in stack layout";
        })
        (mkBind ''mod .." + M"'' "hl.dsp.window.fullscreen_state({ internal = 1, client = 0})" {
          description = "Toggle fullscreen for focused window";
        })
        (mkBind ''mod .." + CTRL + M"'' "hl.dsp.window.fullscreen(1)" {
          description = "Maximize focused window";
        })
        (mkBind ''mod .." + left"'' "hl.dsp.focus({direction = \"l\"})" {
          description = "Move focus left";
        })
        (mkBind ''mod .." + right"'' "hl.dsp.focus({direction = \"r\"})" {
          description = "Move focus right";
        })
        (mkBind ''mod .." + up"'' "hl.dsp.focus({direction = \"u\"})" { description = "Move focus up"; })
        (mkBind ''mod .." + down"'' "hl.dsp.focus({direction = \"d\"})" {
          description = "Move focus down";
        })
        (mkBind ''mod .." + CTRL + left"'' "hl.dsp.window.swap( { direction = \"l\" } )" {
          description = "Swap focused window left";
        })
        (mkBind ''mod .." + CTRL + right"'' "hl.dsp.window.swap( { direction = \"r\" } )" {
          description = "Swap focused window right";
        })
        (mkBind ''mod .." + CTRL + up"'' "hl.dsp.window.swap( { direction = \"u\" } )" {
          description = "Swap focused window up";
        })
        (mkBind ''mod .." + CTRL + down"'' "hl.dsp.window.swap( { direction = \"d\" })" {
          description = "Swap focused window down";
        })
      ]
      ++ (builtins.concatLists (
        builtins.genList (
          i:
          let
            ws = i + 1;
          in
          [
            (mkBind ''mod .." + code:1${toString i}"'' "hl.dsp.focus({ workspace = \"${toString ws}\" })" {
              description = "Switch to workspace ${toString ws}";
            })
            (mkBind ''mod .." + SHIFT + code:1${toString i}"''
              "hl.dsp.window.move({workspace = \"${toString ws}\" })"
              {
                description = "Move window to workspace ${toString ws}";
              }
            )
          ]
        ) 9
      ))
      ++ [
        (mkBind ''mod .." + mouse_up"'' "hl.dsp.focus( { workspace = \"e-1\" } )" {
          description = "Switch to previous non-empty workspace";
        })
        (mkBind ''mod .." + mouse_down"'' "hl.dsp.focus( { workspace = \"e+1\" } )" {
          description = "Switch to next non-empty workspace";
        })
        (mkBind ''mod .." + PAGE_UP"'' "hl.dsp.focus( {workspace = \"r-1\" } )" {
          description = "Switch to previous workspace (including empty)";
        })
        (mkBind ''mod .."+ PAGE_DOWN"'' "hl.dsp.focus( { workspace = \"r+1\" } )" {
          description = "Switch to next workspace (including empty)";
        })
        (mkExec ''mod .." + SHIFT + S"''
          "${pkgs.grim}/bin/grim -g \"$(slurp)\" - | ${pkgs.wl-clipboard}/bin/wl-copy"
          "Take screenshot of selected area and copy to clipboard"
        )
        (mkExec ''mod .." + p"'' "cliphist list | fuzzel --dmenu | cliphist decode | wl-copy"
          "Open clipboard history menu"
        )
      ]
      ++ [
        (mkBind ''mod .." + mouse:272"'' "hl.dsp.window.drag()" { description = "Move window with mouse"; })
        (mkBind ''mod .." + mouse:273"'' "hl.dsp.window.resize()" {
          description = "Resize window with mouse";
        })
        (mkBind ''mod .. " + ALT_L"'' "hl.dsp.window.resize()" {
          description = "Resize window with keyboard and mouse";
        })
      ]
      ++ [
        (mkExecRepeatLocked ''"XF86AudioRaiseVolume"'' "wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
          "Increase volume"
        )
        (mkExecRepeatLocked ''"XF86AudioLowerVolume"'' "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
          "Decrease volume"
        )
        (mkExecRepeatLocked ''"XF86MonBrightnessUp"'' "brightnessctl -e4 -n2 set 5%+"
          "Increase screen brightness"
        )
        (mkExecRepeatLocked ''"XF86MonBrightnessDown"'' "brightnessctl -e4 -n2 set 5%-"
          "Decrease screen brightness"
        )
      ]
      ++ [
        (mkExecLocked ''"XF86AudioNext"'' "playerctl next" "Next track")
        (mkExecLocked ''"XF86AudioPause"'' "playerctl play-pause" "Play/pause")
        (mkExecLocked ''"XF86AudioPlay"'' "playerctl play-pause" "Play/pause")
        (mkExecLocked ''"XF86AudioPrev"'' "playerctl previous" "Previous track")
        (mkExecLocked ''" + switch:[Lid Switch]"'' "hyprlock" "Lock screen when laptop lid is closed")
        (mkExecLocked ''" + switch:on:[Lid Switch]"'' "hyprctl keyword monitor \"eDP-1, disable\""
          "Disable internal display when laptop lid is closed"
        )
        (mkExecLocked ''" + switch:off:[Lid Switch]"''
          "hyprctl keyword monitor \"eDP-1, 2880x1800, 0x0, 1.5\""
          "Re-enable internal display when laptop lid is opened"
        )
      ];
    };

    wayland.windowManager.hyprland.extraConfig = ''
      hl.gesture({
        fingers = 3,
        direction = "horizontal",
        action = "workspace",
      })
    '';
  };
}
