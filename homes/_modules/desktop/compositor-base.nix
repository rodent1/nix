{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.modules.desktop;
  compositorEnabled = cfg.environments.niri.enable || cfg.environments.hyprland.enable;
  onlyShowIn = "Hyprland;Niri;";
in
{
  config = lib.mkIf (cfg.enable && compositorEnabled) {
    programs.fuzzel.enable = true;

    home.packages = with pkgs; [
      eog
      evince
      file-roller
      gnome-calculator
      gnome-text-editor
      mako
      nautilus
      polkit_gnome
      showtime
    ];

    xdg.configFile = {
      "autostart/mako.desktop".text = ''
        [Desktop Entry]
        Type=Application
        Name=Mako
        Exec=${lib.getExe pkgs.mako}
        OnlyShowIn=${onlyShowIn}
      '';

      "autostart/polkit-gnome-authentication-agent-1.desktop".text = ''
        [Desktop Entry]
        Type=Application
        Name=Polkit GNOME Authentication Agent
        Exec=${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1
        OnlyShowIn=${onlyShowIn}
      '';
    };
  };
}
