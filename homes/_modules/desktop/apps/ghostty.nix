_: {
  config = {
    programs.ghostty = {
      enable = true;
      enableFishIntegration = true;

      settings = {
        confirm-close-surface = false;
        link-url = true;
        window-decoration = "none";

        keybind = [
          "ctrl+v=paste_from_clipboard"
        ];
      };
    };

    catppuccin.ghostty.enable = true;
  };
}
