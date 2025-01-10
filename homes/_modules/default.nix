{ pkgs, ... }:
{
  imports = [
    ./mutability.nix

    ./development
    ./kubernetes
    ./security
    ./services
    ./shell
    ./themes
  ];

  config = {
    home.stateVersion = "24.05";

    programs = {
      home-manager.enable = true;
      nix-index-database.comma.enable = true;
      nix-index.enable = true;
    };

    xdg.enable = true;

    home.packages = [ pkgs.home-manager ];
  };
}
