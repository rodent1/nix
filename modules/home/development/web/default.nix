{
  internal.homeModules.default =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    let
      cfg = config.modules.development;
      playwrightPackage = pkgs.unstable.playwright-driver;
      playwrightBrowsers = playwrightPackage.selectBrowsers {
        withChromium = true;
        withChromiumHeadlessShell = true;
        withFirefox = false;
        withWebkit = false;
      };
      actualPlaywrightVersion = playwrightPackage.version;
    in
    {
      config = lib.mkIf cfg.enable {
        home.packages = [
          playwrightBrowsers
        ];

        home.sessionVariables = {
          PLAYWRIGHT_BROWSERS_PATH = "${playwrightBrowsers}";
          PLAYWRIGHT_DRIVER_VERSION = actualPlaywrightVersion;
          PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD = "1";
        };
      };
    };
}
