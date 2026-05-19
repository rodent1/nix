{
  flake.modules.nixos.users =
    { config, primaryUser, ... }:
    let
      ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
    in
    {
      users = {
        mutableUsers = true;

        users = {
          root = {
            isSystemUser = true;
          };

          ${primaryUser} = {
            isNormalUser = true;
            uid = 1000;

            group = primaryUser;

            extraGroups = [
              "wheel"
            ]
            ++ ifTheyExist [
              "network"
              "docker"
              "git"
            ];
          };
        };

        groups = {
          ${primaryUser}.gid = 1000;
        };
      };
    };
}
