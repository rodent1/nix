{
  internal.homeModules.desktop =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      config = lib.mkIf config.modules.desktop.enable {
        home.packages = [ pkgs.chatgpt-desktop-app ];
      };
    };
}
