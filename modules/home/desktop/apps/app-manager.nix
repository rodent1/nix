{ inputs, ... }:
{
  internal.homeModules.desktop =
    { pkgs, ... }:
    {
      home.packages = [ inputs.app-manager.packages.${pkgs.stdenv.hostPlatform.system}.default ];

      programs.umbriel.settings.window_rule = [
        {
          match.app_id = "^com\\.github\\.AppManager$";
          default_floating = true;
        }
      ];
    };
}
