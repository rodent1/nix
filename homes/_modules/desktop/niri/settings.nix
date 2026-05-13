{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.modules.desktop.environments.niri;

  inherit (config.modules.themes.catppuccin) cursors;
  noctalia =
    cmd:
    [
      "noctalia-shell"
      "ipc"
      "call"
    ]
    ++ (pkgs.lib.splitString " " cmd);
in
{
  config = lib.mkIf (config.modules.desktop.enable && cfg.enable) {
    programs.niri = {
      package = pkgs.unstable.niri;

      settings = {
        xwayland-satellite.path = lib.getExe pkgs.xwayland-satellite;
        cursor.theme = lib.mkIf cursors.enable "catppuccin-${cursors.flavor}-${cursors.accent}-cursors";

        input.keyboard.xkb = {
          layout = "no";
          variant = "nodeadkeys";
        };

        switch-events = lib.mkIf cfg.noctalia.enable {
          lid-close.action.spawn = noctalia "sessionMenu lockAndSuspend";
        };

        hotkey-overlay = {
          skip-at-startup = true;
        };

        layout = {
          background-color = "transparent";
        };

        # Uncomment this line to ask the clients to omit their client-side decorations if possible.
        # If the client will specifically ask for CSD, the request will be honored.
        # Additionally, clients will be informed that they are tiled, removing some rounded corners.
        # prefer-no-csd = true;
      };
    };
  };
}
