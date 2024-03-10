{ config, lib, ... }:
with lib;

let
  deviceCfg = config.modules.device;
in
{
  imports = [
    ./users

    ./system/vscode-server
    ./system/wsl
  ];



  boot.initrd.systemd.enable = true;

  networking.hostId = deviceCfg.hostId;

  i18n = {
    defaultLocale = mkDefault "en_US.UTF-8";
  };

  nix.gc.dates = "weekly";

  documentation.nixos.enable = false;

  # Increase open file limit for sudoers
  security.pam.loginLimits = [
    {
      domain = "@wheel";
      item = "nofile";
      type = "soft";
      value = "524288";
    }
    {
      domain = "@wheel";
      item = "nofile";
      type = "hard";
      value = "1048576";
    }
  ];

  system.stateVersion = "23.11";
}
