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
    };
}
