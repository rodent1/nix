{
  internal.homeModules.desktop =
    { config, ... }:
    let
      package = config.programs.luciole.package;
    in
    {
      programs.luciole.enable = true;

      # The default file manager. ~/.config/mimeapps.list stays writable for
      # applications and takes precedence, so the folder default goes in the
      # lower-priority data-home list.
      xdg.dataFile = {
        "applications/mimeapps.list".text = ''
          [Default Applications]
          inode/directory=dev.noctalia.luciole.desktop
        '';

        # Answer "show in folder" requests from other applications.
        "dbus-1/services/org.freedesktop.FileManager1.service".source =
          "${package}/share/dbus-1/services/dev.noctalia.luciole.FileManager1.service";
      };

      programs.umbriel.settings.window_rule = [
        {
          match.app_id = "^dev\\.noctalia\\.luciole$";
          default_floating = true;
        }
      ];
    };
}
