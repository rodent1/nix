{ ... }:
{
  config = {
    wsl = {
      enable = true;
      defaultUser = "stianrs";

      wslConf.interop.appendWindowsPath = false;
      wslConf.network.generateHosts = false;
    };

    programs.nix-ld.enable = true;
  };
}
