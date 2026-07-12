{
  internal.homeModules.gamer =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.modules.desktop;
    in
    {
      config = lib.mkIf cfg.enable {

        home.packages = with pkgs; [
          nvtopPackages.nvidia
          mangohud
          unstable.rusty-path-of-building
          wagoapp
        ];
      };
    };
}
