{
  pkgs,
  ...
}:

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

      prefer-no-csd = true;

      hotkey-overlay = {
        skip-at-startup = true;
      };

      environment = {
        CLUTTER_BACKEND = "wayland";
        GDK_BACKEND = "wayland,x11";
        MOZ_ENABLE_WAYLAND = "1";
        NIXOS_OZONE_WL = "1";
        QT_QPA_PLATFORM = "wayland";
        QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
        ELECTRON_OZONE_PLATFORM_HINT = "auto";

        XDG_SESSION_TYPE = "wayland";
        XDG_CURRENT_DESKTOP = "niri";
        DISPLAY = ":0";
      };
    };
  };
}
