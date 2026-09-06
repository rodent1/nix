{
  internal.homeModules.desktop =
    {
      config,
      lib,
      ...
    }:
    {
      config = lib.mkIf config.modules.desktop.enable {
        programs.codexDesktopLinux = {
          enable = true;
          computerUseUi.enable = true;
          remoteMobileControl.enable = true;
        };

        wayland.windowManager.hyprland = lib.mkIf config.modules.desktop.noctalia.enable {
          extraConfig = ''
            hl.env("CODEX_OZONE_PLATFORM", "wayland");
          '';
        };
      };
    };
}
