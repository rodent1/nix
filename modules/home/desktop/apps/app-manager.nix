{ inputs, ... }:
{
  internal.homeModules.desktop =
    { pkgs, ... }:
    {
      home.packages = [ inputs.app-manager.packages.${pkgs.stdenv.hostPlatform.system}.default ];

      wayland.windowManager.hyprland.extraConfig = ''
        hl.window_rule({
          match = { class = "com.github.AppManager" },
          float = true,
        })
      '';

      programs.umbriel.settings.window_rule = [
        {
          match.app_id = "^com\\.github\\.AppManager$";
          default_floating = true;
        }
      ];
    };
}
