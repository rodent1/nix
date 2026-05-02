{
  config,
  pkgs,
  ...
}:
let
  noctalia =
    cmd:
    [
      "noctalia-shell"
      "ipc"
      "call"
    ]
    ++ (pkgs.lib.splitString " " cmd);

  apps = import ./applications.nix { inherit pkgs; };
in
{
  programs.niri.settings.binds = with config.lib.niri.actions; {
    # Volume
    "XF86AudioRaiseVolume".action.spawn = noctalia "volume increase"; # output increase
    "XF86AudioRaiseVolume".allow-when-locked = true;
    "XF86AudioLowerVolume".action.spawn = noctalia "volume decrease"; # output decrease
    "XF86AudioLowerVolume".allow-when-locked = true;
    "XF86AudioMute".action.spawn = noctalia "volume muteOutput"; # output mute
    "XF86AudioMute".allow-when-locked = true;
    "shift+XF86AudioRaiseVolume".action.spawn = noctalia "volume increaseInput"; # input increase
    "shift+XF86AudioRaiseVolume".allow-when-locked = true;
    "shift+XF86AudioLowerVolume".action.spawn = noctalia "volume decreaseInput"; # input decrease
    "shift+XF86AudioLowerVolume".allow-when-locked = true;
    "shift+XF86AudioMute".action.spawn = noctalia "volume muteInput"; # input mute
    "shift+XF86AudioMute".allow-when-locked = true;
    "control+XF86AudioMute".action.spawn = noctalia "volume togglePanel"; # open volume panel

    # Brightness
    "XF86MonBrightnessUp".action.spawn = noctalia "brightness increase";
    "XF86MonBrightnessUp".allow-when-locked = true;
    "XF86MonBrightnessDown".action.spawn = noctalia "brightness decrease";
    "XF86MonBrightnessDown".allow-when-locked = true;

    # Media
    "XF86AudioPlay".action.spawn = noctalia "media playPause";
    "XF86AudioNext".action.spawn = noctalia "media next";
    "XF86AudioPrev".action.spawn = noctalia "media previous";

    "super+Space".action.spawn = noctalia "launcher toggle";
    "super+O".action = toggle-overview;
    "super+O".repeat = false;
    "super+Q".action = close-window;
    "super+Q".repeat = false;

    "super+B".action.spawn = apps.browser;
    "super+Return".action.spawn = apps.terminal;
    "super+E".action.spawn = apps.fileManager;
    "super+L".action.spawn = noctalia "lockScreen lock";

    "super+Left".action = focus-column-left;
    "super+Right".action = focus-column-right;
    "super+Down".action = focus-window-down;
    "super+Up".action = focus-window-up;

    "super+Ctrl+Left".action = move-column-left;
    "super+Ctrl+Right".action = move-column-right;
    "super+Ctrl+Down".action = move-window-down;
    "super+Ctrl+Up".action = move-window-up;

    "super+Home".action = focus-column-first;
    "super+End".action = focus-column-last;
    "super+Ctrl+Home".action = move-column-to-first;
    "super+Ctrl+End".action = move-column-to-last;

    "super+Shift+Left".action = focus-monitor-left;
    "super+Shift+Right".action = focus-monitor-right;
    "super+Shift+Down".action = focus-monitor-down;
    "super+Shift+Up".action = focus-monitor-up;

    "super+Shift+Ctrl+Left".action = move-column-to-monitor-left;
    "super+Shift+Ctrl+Right".action = move-column-to-monitor-right;
    "super+Shift+Ctrl+Down".action = move-column-to-monitor-down;
    "super+Shift+Ctrl+Up".action = move-column-to-monitor-up;

    "super+Page_Down".action = focus-workspace-down;
    "super+Page_Up".action = focus-workspace-up;
    "super+Ctrl+Page_Down".action = move-column-to-workspace-down;
    "super+Ctrl+Page_Up".action = move-column-to-workspace-up;

    "super+WheelScrollUp".action = focus-workspace-up;
    "super+WheelScrollUp".cooldown-ms = 150;
    "super+WheelScrollDown".action = focus-workspace-down;
    "super+WheelScrollDown".cooldown-ms = 150;
    "super+Ctrl+WheelScrollUp".action = move-column-to-workspace-up;
    "super+Ctrl+WheelScrollUp".cooldown-ms = 150;
    "super+Ctrl+WheelScrollDown".action = move-column-to-workspace-down;
    "super+Ctrl+WheelScrollDown".cooldown-ms = 150;

    "super+1".action = focus-workspace "main";
    "super+2".action = focus-workspace "browser";
    "super+3".action = focus-workspace "discord";

    # Consume one window from the right to the bottom of the focused column.
    "super+Comma".action = consume-window-into-column;
    # Expel the bottom window from the focused column to the right.
    "super+Period".action = expel-window-from-column;
    # Cycle through widths set in preset-column-widths.
    "super+R".action = switch-preset-column-width;
    # Cycle through widths set in preset-column-widths in reverse order.
    "super+Shift+R".action = switch-preset-column-width-back;
    "super+Ctrl+Shift+R".action = switch-preset-window-height;
    "super+Ctrl+R".action = reset-window-height;

    "super+F".action = maximize-column;
    "super+Shift+F".action = fullscreen-window;
    "super+Ctrl+F".action = expand-column-to-available-width;
    "super+M".action = maximize-window-to-edges;
    "super+C".action = center-column;
    "super+Ctrl+C".action = center-visible-columns;

    "super+Minus".action = set-column-width "-10%";
    "super+Plus".action = set-column-width "+10%";

    "super+V".action = toggle-window-floating;
    "super+Shift+V".action = switch-focus-between-floating-and-tiling;
    "super+W".action = toggle-column-tabbed-display;

    "Print".action.screenshot = [ ];
    "super+P".action.screenshot = [ ];
    "super+Ctrl+P".action.screenshot-screen = [ ];
    "Ctrl+Print".action.screenshot-screen = [ ];
    "super+Alt+P".action.screenshot-window = [ ];
    "Alt+Print".action.screenshot-window = [ ];
  };
}
