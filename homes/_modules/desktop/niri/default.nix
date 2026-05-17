_: {
  imports = [
    ./autostart.nix
    ./keybinds.nix
    ./noctalia.nix
    ./rules.nix
    ./settings.nix
  ];

  programs.fuzzel.enable = true; # application launcher

  services = {
    mako.enable = true; # notification daemon
    swayidle.enable = true; # idle management daemon
    polkit-gnome.enable = true; # polkit agent
  };
}
