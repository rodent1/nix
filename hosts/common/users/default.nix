{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  users.users = {
    stianrs = {
      isNormalUser = true;
      extraGroups = ["wheel"];
      packages = [ pkgs.home-manager ];
    };
  };

  home-manager = {
    extraSpecialArgs = { inherit inputs outputs; };
    users = {
      # Import your home-manager configuration
      stianrs = import ../../../home-manager/home.nix;
    };
  };

  users.users.stianrs = {
    shell = pkgs.fish;
  };
}
