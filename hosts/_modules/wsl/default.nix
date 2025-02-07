{ pkgs, ... }:
{
  config = {
    wsl = {
      enable = true;
      defaultUser = "stianrs";
    };

    environment.systemPackages = with pkgs; [ wslu ];

    programs.nix-ld.enable = true;
  };
}
