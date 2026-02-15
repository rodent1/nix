{ pkgs, ... }:
{
  imports = [
    ./mutability.nix

    ./development
    ./kubernetes
    ./security
    ./shell
    ./themes
  ];

  config = {
    home.stateVersion = "24.05";

    programs = {
      home-manager.enable = true;

      nix-index.enable = true;
      nix-index-database.comma.enable = true;
      command-not-found.enable = false;
    };

    xdg.enable = true;

    home.packages = [ pkgs.home-manager ];
  };
}
