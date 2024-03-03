{
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
}
