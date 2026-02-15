_: {
  config = {
    wsl = {
      enable = true;
      defaultUser = "stianrs";

      wslConf = {
        interop.appendWindowsPath = false;
        network.generateHosts = false;
      };
    };
  };
}
