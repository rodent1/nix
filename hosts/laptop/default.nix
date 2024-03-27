{ pkgs, lib, config, hostname, ... }:
let
  ifGroupsExist = groups:
    builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in {
  imports = [ ./hardware-configuration.nix ../_modules/wsl ];

  config = {
    networking = { hostName = hostname; };

    users.users.stianrs = {
      uid = 1000;
      name = "stianrs";
      home = "/home/stianrs";
      group = "stianrs";
      shell = pkgs.fish;
      openssh.authorizedKeys.keys = lib.strings.splitString "\n"
        (builtins.readFile ../../homes/stianrs/config/ssh/ssh.pub);
      isNormalUser = true;
      extraGroups = [ "wheel" "users" ]
        ++ ifGroupsExist [ "network" "samba-users" ];
    };
    users.groups.stianrs = { gid = 1000; };
  };

  # # Use the systemd-boot EFI boot loader.
  # boot.loader.systemd-boot.enable = true;
  # boot.loader.efi.canTouchEfiVariables = true;
}
