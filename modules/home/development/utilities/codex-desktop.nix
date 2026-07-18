{
  internal.homeModules.default =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.modules.development.web.codex-desktop;
    in
    {
      options.modules.development.web.codex-desktop = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = config.modules.development.web.enable && config.modules.desktop.enable;
          description = "Enable Codex Desktop for Linux";
        };
      };

      config = lib.mkIf cfg.enable {
        programs.codexDesktopLinux = {
          enable = true;
          cliPackage = pkgs.unstable.codex;

          computerUseUi.enable = true;
          remoteControl.enable = true;
          remoteMobileControl.enable = true;

          linuxFeatures = [
            "appshots"
            "open-target-discovery"
          ];
        };
      };
    };
}
