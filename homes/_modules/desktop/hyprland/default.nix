{
  pkgs,
  ...
}:
{
  wayland.windowManager.hyprland = {
    enable = true;
    package = pkgs.unstable.hyprland;
  };

  services.hyprpolkitagent.enable = true;

  home.packages = with pkgs; [
    kitty
    unstable.hyprlauncher
    waybar
  ];
}
