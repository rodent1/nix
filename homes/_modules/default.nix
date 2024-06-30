{ pkgs, ... }:
{
  imports = [
    ./mutability.nix

    ./development
    ./kubernetes
    ./security
    ./services
    ./shell
  ];

  config = {
    home.stateVersion = "24.05";

    programs = {
      home-manager.enable = true;

      nix-index.enable = true;
      nix-index.enableFishIntegration = true;
      nix-index-database.comma.enable = true;
    };

    xdg.enable = true;

    home.packages = [ pkgs.home-manager ];
  };
}
