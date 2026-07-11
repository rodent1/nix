{
  rodent.homeModules.desktop = _: {
    config = {
      programs.ghostty = {
        enable = true;
        enableFishIntegration = true;

        settings = {
          confirm-close-surface = false;
          maximize = true;
          link-url = true;

          keybind = [
            "ctrl+v=paste_from_clipboard"
          ];
        };
      };

      catppuccin.ghostty.enable = true;
    };
  };
}
