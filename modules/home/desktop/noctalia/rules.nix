{
  internal.homeModules.desktop = _: {
    programs.umbriel.settings = {
      layer_rule = [
        {
          match.namespace = "^noctalia-(bar-.+|notification|dock|panel|attached-panel|osd|window-switcher)$";
          blur = true;
          blur_popups = true;
          blur_ignore_alpha = 0.5;
          # Panels open over windows, so blur what is behind them rather than
          # the cached wallpaper.
          blur_optimized = false;
        }
      ];

      window_rule = [
        {
          match.app_id = "^dev\\.noctalia\\.Noctalia$";
          default_floating = true;
          default_floating_size_px = {
            width = 1080;
            height = 920;
          };
        }
      ];
    };
  };
}
