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
        programs.firefox = {
          enable = true;
          package = pkgs.unstable.firefox;

          languagePacks = [
            "en-GB"
            "no-NO"
          ];
        };
      };
    };
}
