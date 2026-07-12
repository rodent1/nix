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
        programs.vscode = {
          enable = true;
          package = pkgs.unstable.vscode;
        };
      };
    };
}
