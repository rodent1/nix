{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.modules.users.stianrs;
  ifGroupsExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in
{
  options.modules.users.stianrs = {
    extraGroups = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
    };

    hashedPasswordFile = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
    };

    packages = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [ ];
    };
  };

  config = {
    users.users.stianrs = {
      uid = 1000;
      name = "stianrs";
      home = "/home/stianrs";
      group = "stianrs";
      shell = pkgs.fish;
      openssh.authorizedKeys.keys = lib.strings.splitString "\n" (
        builtins.readFile ../../../../homes/stianrs/config/ssh/ssh.pub
      );
      isNormalUser = true;
      description = "Stian Rossavik Sporaland";
      extraGroups = [
        "wheel"
        "users"
      ]
      ++ ifGroupsExist (
        [
          "network"
          "networkmanager"
          "samba-users"
          "docker"
        ]
        ++ cfg.extraGroups
      );
      inherit (cfg) packages;
    }
    // lib.optionalAttrs (cfg.hashedPasswordFile != null) {
      inherit (cfg) hashedPasswordFile;
    };

    users.groups.stianrs = {
      gid = 1000;
    };
  };
}
