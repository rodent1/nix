{
  internal.homeModules.desktop =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      codexCli = pkgs.unstable.codex;
    in
    {
      config = lib.mkIf config.modules.desktop.enable {
        programs.codexDesktopLinux = {
          enable = true;
          cliPackage = codexCli;

          remoteControl = {
            enable = true;
            package = codexCli;
          };

          computerUseUi.enable = true;
          remoteMobileControl.enable = true;
        };
      };
    };
}
