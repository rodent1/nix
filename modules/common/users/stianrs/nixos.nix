{
  config,
  ...
}:
let
  ifGroupsExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in {
  users.users.stianrs = {
    isNormalUser = true;
    uid = 1000;
    extraGroups = [
      "wheel"
    ] ++ ifGroupsExist [
      "network"
      "samba-users"
    ];

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEWyQ5lrpe2f0pOXdtWch1BDNbkccWVC6bUwr0htQPq0"
    ];
  };
}
