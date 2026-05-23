{
  hostname,
  pkgs,
  ...
}:
{
  imports = [
    ./hostconfig/${hostname}.nix
    ./hypridle.nix
    ./keybinds.nix
    ./settings.nix
    ./wayle.nix
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = false;
  };

  programs = {
    hyprlock.enable = true;
  };

  services = {
    hyprpolkitagent.enable = true; # polkit agent for Hyprland
  };

  home.packages = with pkgs; [
    brightnessctl
    libappindicator-gtk3
    playerctl
    unstable.hyprlauncher
  ];
}
