{
  config,
  lib,
  ...
}:
let
  cfg = config.modules.desktop.niri;
in
{
  config = lib.mkIf (cfg.enable && cfg.noctalia.enable) {
    programs.niri.settings.spawn-at-startup = [
      { command = [ "noctalia-shell" ]; }
    ];
  };
}
