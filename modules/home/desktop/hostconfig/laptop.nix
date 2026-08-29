{
  internal.homeModules.laptop =
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
          brightnessctl
          ddcutil
        ];
      };
    };
}
