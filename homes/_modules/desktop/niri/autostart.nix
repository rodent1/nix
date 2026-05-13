{
  config,
  lib,
  ...
}:
let
  cfg = config.modules.desktop.environments.niri;
in
{
  config = lib.mkIf (cfg.enable && cfg.noctalia.enable) {
    programs.niri.settings.spawn-at-startup = [
      { command = [ "noctalia-shell" ]; }
    ];
  };
}
