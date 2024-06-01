{pkgs, ...}: {
  imports = [
    ./mutability.nix

    ./development
    ./editor
    ./kubernetes
    ./security
    ./shell
    ./virtualisation
  ];

  config = {
    home.stateVersion = "23.11";

    programs = {home-manager.enable = true;};

    xdg.enable = true;

    home.packages = [pkgs.home-manager];
  };
}
