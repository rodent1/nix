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
    "XF86AudioLowerVolume".action.spawn = noctalia "volume decrease"; # output decrease
    "XF86AudioMute".action.spawn = noctalia "volume muteOutput"; # output mute
    "shift+XF86AudioRaiseVolume".action.spawn = noctalia "volume increaseInput"; # input increase
    "shift+XF86AudioLowerVolume".action.spawn = noctalia "volume decreaseInput"; # input decrease
    "shift+XF86AudioMute".action.spawn = noctalia "volume muteInput"; # input mute
    "control+XF86AudioMute".action.spawn = noctalia "volume togglePanel"; # open volume panel

    # Brightness
    "XF86MonBrightnessUp".action.spawn = noctalia "brightness increase";
    "XF86MonBrightnessDown".action.spawn = noctalia "brightness decrease";

    # Media
    "XF86AudioPlay".action.spawn = noctalia "media playPause";
    "XF86AudioNext".action.spawn = noctalia "media next";
    "XF86AudioPrev".action.spawn = noctalia "media previous";

    "super+Space".action.spawn = noctalia "launcher toggle";
    "super+q".action = close-window;
    "super+b".action = spawn apps.browser;
    "super+Return".action = spawn apps.terminal;
    "super+E".action = spawn apps.fileManager;
    "super+L".action.spawn = noctalia "lockScreen lock";

    # 1Passord quick access
    "super+p".action = spawn [
      "${pkgs._1password-gui}/bin/1password"
      "--quick-access"
    ];

    "super+f".action = fullscreen-window;
    "super+t".action = toggle-window-floating;

    "super+Left".action = focus-column-left;
    "super+Right".action = focus-column-right;
    "super+Down".action = focus-workspace-down;
    "super+Up".action = focus-workspace-up;

    "super+Shift+Left".action = move-column-left;
    "super+Shift+Right".action = move-column-right;
    "super+Shift+Down".action = move-column-to-workspace-down;
    "super+Shift+Up".action = move-column-to-workspace-up;

    "super+1".action = focus-workspace "main";
    "super+2".action = focus-workspace "browser";
    "super+3".action = focus-workspace "discord";
  };
}
