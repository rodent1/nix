{
  internal.homeModules.desktop =
    { pkgs, ... }:
    {
      home.file.".face".source = ./_assets/profile.jpg;
      home.packages = with pkgs; [
        ffmpegthumbnailer
        unstable.waytator
      ];

      wayland.windowManager.hyprland.extraConfig = ''
        hl.window_rule({
          match = { class = "dev.faetalize.waytator" },
          float = true,
        })
      '';

      programs.umbriel.settings.window_rule = [
        {
          match.app_id = "^dev\\.faetalize\\.waytator$";
          default_floating = true;
        }
      ];
    };
}
