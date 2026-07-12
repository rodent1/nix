{
  internal.nixosModules.default =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      ifGroupsExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
    in
    {
      users = {
        mutableUsers = true;

        users.stianrs = {
          uid = 1000;
          name = "stianrs";
          home = "/home/stianrs";
          group = "stianrs";
          shell = pkgs.fish;
          openssh.authorizedKeys.keys = lib.strings.splitString "\n" (
            builtins.readFile ../../home/_assets/ssh/ssh.pub
          );
          isNormalUser = true;
          description = "Stian Rossavik Sporaland";
          extraGroups = [
            "wheel"
            "users"
          ]
          ++ ifGroupsExist [
            "network"
            "networkmanager"
            "samba-users"
            "docker"
          ];
        };

        groups.stianrs = {
          gid = 1000;
        };
      };
    };
}
