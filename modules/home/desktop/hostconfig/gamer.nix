{
  internal.homeModules.gamer =
    {
      osConfig,
      lib,
      pkgs,
      ...
    }:
    {
      config = lib.mkIf osConfig.modules.desktop.enable {

        home.packages = with pkgs; [
          nvtopPackages.nvidia
          mangohud
          unstable.rusty-path-of-building
        ];
      };
    };
}
