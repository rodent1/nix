_: {
  config = {
    modules.desktop.environments.niri.settings = {
      outputs = {
        "eDP-1" = {
          enable = true;
          scale = 1.5;
        };
      };

      workspaces = {
        "1".name = "browser";
        "2".name = "discord";
        "3".name = "main";
      };
    };
  };
}
