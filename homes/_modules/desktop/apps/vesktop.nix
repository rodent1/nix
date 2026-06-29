_: {
  config = {
    programs.vesktop = {
      enable = false; # TODO: fix pnpm error
      settings = {
        minimizeToTray = true;
        arRPC = true;
      };

      vencord.settings = {
        frameless = true;
      };
    };
  };
}
