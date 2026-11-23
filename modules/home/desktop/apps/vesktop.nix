{
  internal.homeModules.desktop =
    { pkgs, ... }:
    {
      programs.vesktop = {
        enable = true;
        package = pkgs.unstable.vesktop;
      };

      # Host bundles place the Discord workspace on a monitor.
      wayland.windowManager.hyprland.extraConfig = ''
        hl.on("hyprland.start", function()
          hl.exec_cmd("vesktop")
        end)

        hl.window_rule({
          name = "Discord",
          match = { initial_class = "vesktop" },
          workspace = "name:Discord silent",
        })
      '';

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
