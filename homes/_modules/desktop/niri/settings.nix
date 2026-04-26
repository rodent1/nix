{
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
in
{
  programs.niri = {
    enable = true;
    package = pkgs.niri;
    settings = {
      workspaces = {
        "main" = { };
        "browser" = { };
        "discord" = { };
      };

      switch-events = {
        lid-close.action.spawn = noctalia "sessionMenu lockAndSuspend";
      };

      hotkey-overlay = {
        skip-at-startup = true;
      };

      # Uncomment this line to ask the clients to omit their client-side decorations if possible.
      # If the client will specifically ask for CSD, the request will be honored.
      # Additionally, clients will be informed that they are tiled, removing some rounded corners.
      prefer-no-csd = true;
    };
  };
}
