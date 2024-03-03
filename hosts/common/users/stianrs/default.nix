{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: let
  ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in {

  users.mutableUsers = false;
  users.users.stian = {
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups =
      [
        "wheel"
      ]
      ++ ifTheyExist [
        "network"
        "docker"
        "git"
      ];

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEWyQ5lrpe2f0pOXdtWch1BDNbkccWVC6bUwr0htQPq0"
    ];
    packages = [pkgs.home-manager];
  };

  home-manager.extraSpecialArgs = { inherit inputs outputs; };
  home-manager.users.stianrs = import ../../../../home-manager/home.nix;
}
