{
  internal.homeModules.default =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.modules.development.codex;
    in
    {
      options.modules.development.codex = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = config.modules.development.enable;
          description = "Enable Codex";
        };
      };

      config = lib.mkIf cfg.enable {
        programs.codex = {
          enable = true;
          package = pkgs.unstable.codex;
        };
      };
    };
}
