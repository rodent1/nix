{
  internal.homeModules.desktop = _: {
    programs.ghostty = {
      enable = true;
      enableFishIntegration = true;

      settings = {
        confirm-close-surface = false;
        link-url = true;
        window-decoration = "client";

        keybind = [
          "ctrl+v=paste_from_clipboard"
        ];
      };
    };

    catppuccin.ghostty.enable = true;
  };
}
