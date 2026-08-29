{
  internal.homeModules.default =
    { config, lib, ... }:
    {
      config = lib.mkIf config.modules.desktop.enable {
        programs.google-chrome = {
          enable = true;

          commandLineArgs = [
            "--enable-features=MiddleClickAutoscroll"
            # Keep OSCrypt on the same backend in Plasma and Hyprland.
            "--password-store=kwallet6"
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
