let
  extensions = [
    "hehggadaopoacecdllhhajmbjkdcmajg" # ChatGPT
    "aeblfdkhhhdcdjpifhhbdiojplfjncoa" # 1Password
    "ddkjiahejlhfcafbddmgiahcphecmpfh" # uBlock Origin Lite (Manifest V3)
  ];
in
{
  # Google Chrome only loads externally installed extensions from system-managed
  # directories on Linux, so install them through NixOS browser policies.
  internal.nixosModules.default =
    { config, lib, ... }:
    {
      config = lib.mkIf (!(config.wsl.enable or false)) {
        programs.chromium = {
          enable = true;
          extensions = extensions;
        };
      };
    };

  internal.homeModules.desktop =
    { config, lib, ... }:
    {
      config = lib.mkIf config.modules.desktop.enable {
        programs.google-chrome.enable = true;
      };
    };
}
