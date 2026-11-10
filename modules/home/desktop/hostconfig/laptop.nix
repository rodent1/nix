{
  internal.homeModules.laptop =
    {
      osConfig,
      lib,
      pkgs,
      ...
    }:
    {
      config = lib.mkIf osConfig.modules.desktop.enable {

        home.packages = with pkgs; [
          brightnessctl
          ddcutil
        ];
      };
    };
}
