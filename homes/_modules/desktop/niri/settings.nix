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
    };
  };
}
