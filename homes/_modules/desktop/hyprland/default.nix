{
  pkgs,
  ...
}:
{
  imports = [
    ./hypridle.nix
    ./keybinds.nix
    ./wayle.nix
  ];

  programs = {
    hyprlock.enable = true; # screen locker for Hyprland
  };

  services = {
    hyprpolkitagent.enable = true; # polkit agent for Hyprland
  };

  home.packages = with pkgs; [
    kitty
    unstable.hyprlauncher
  ];
}
