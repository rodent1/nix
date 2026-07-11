{
  rodent.homeModules.default =
    { pkgs, ... }:
    {
      config = {
        home.stateVersion = "26.05";

        programs = {
          home-manager.enable = true;

          nix-index.enable = true;
          nix-index-database.comma.enable = true;
          command-not-found.enable = false;
        };

        xdg.enable = true;

        home.packages = [ pkgs.home-manager ];
      };
    };
}
