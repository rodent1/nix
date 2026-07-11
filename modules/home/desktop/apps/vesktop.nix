{
  rodent.homeModules.desktop = _: {
    config = {
      programs.vesktop = {
        enable = true;
        settings = {
          minimizeToTray = true;
          arRPC = true;
        };

        vencord.settings = {
          frameless = true;
        };
      };
    };
  };
}
