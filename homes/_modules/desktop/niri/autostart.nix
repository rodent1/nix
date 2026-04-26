{
  ...
}:

{
  programs.niri.settings.spawn-at-startup = [
    { command = [ "arrpc" ]; }
    { command = [ "xwayland-satellite" ]; }
    { command = [ "noctalia-shell" ]; }
  ];
}
