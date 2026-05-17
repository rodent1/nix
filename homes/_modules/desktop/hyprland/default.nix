{
  pkgs,
  ...
}:
{
  imports = [
    ./keybinds.nix
    ./waybar.nix
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    package = pkgs.unstable.hyprland;
  };

  programs = {
    hyprlock.enable = true; # screen locker for Hyprland
  };

  services = {
    hyprpolkitagent.enable = true; # polkit agent for Hyprland
    hypridle.enable = true; # idle management daemon for Hyprland
    mako.enable = true; # notification daemon
  };

  home.packages = with pkgs; [
    kitty
    unstable.hyprlauncher
  ];
}
