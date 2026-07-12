{
  internal.homeModules.desktop =
    { pkgs, ... }:
    {
      config = {
        programs.vscode = {
          enable = true;
          package = pkgs.unstable.vscode;
        };
      };
    };
}
