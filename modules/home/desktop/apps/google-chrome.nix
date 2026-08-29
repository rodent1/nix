{
  internal.homeModules.default =
    { config, lib, ... }:
    {
      config = lib.mkIf config.modules.desktop.enable {
        programs.google-chrome = {
          enable = true;

          commandLineArgs = [
            "--enable-features=MiddleClickAutoscroll"
          ];
        };

        programs.chromium = {
          enable = true;
          extensions = [
            "hehggadaopoacecdllhhajmbjkdcmajg" # ChatGPT
            "aeblfdkhhhdcdjpifhhbdiojplfjncoa" # 1Password
            "ddkjiahejlhfcafbddmgiahcphecmpfh" # uBlock Origin Lite (Manifest V3)
          ];
        };
      };
    };
}
