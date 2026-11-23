{
  internal.homeModules.desktop =
    { pkgs, ... }:
    {
      programs.vesktop = {
        enable = true;
        package = pkgs.unstable.vesktop;
      };

      # Host bundles place the Discord workspace on a monitor.
      programs.umbriel.settings = {
        general.autostart = [ "vesktop" ];

        window_rule = [
          {
            match.app_id = "^vesktop$";
            default_workspace = "Discord";
            default_focused = false;
          }
        ];
      };
    };
}
