{
  internal.homeModules.default =
    {
      lib,
      config,
      pkgs,
      ...
    }:
    let
      cfg = config.modules.shell.mise;
    in
    {
      options.modules.shell.mise = {
        enable = lib.mkEnableOption "mise";
      };

      config = lib.mkIf cfg.enable {

        programs = {
          mise = {
            enable = true;
            package = pkgs.unstable.mise;
            enableFishIntegration = true;
          };
        };
      };
    };
}
