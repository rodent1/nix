{
  internal.homeModules.desktop =
    { pkgs, ... }:
    {
      programs.vscode = {
        enable = true;
        package = pkgs.unstable.vscode;
      };
    };
}
