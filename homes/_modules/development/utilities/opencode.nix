{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.modules.development.opencode;
in
{
  options.modules.development.opencode = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = config.modules.development.enable;
      description = "Enable OpenCode";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.opencode = {
      enable = true;
      package = pkgs.unstable.opencode;

      settings = {
        formatter = true;
        lsp = true;

        mcp = {
          executor = {
            type = "remote";
            url = "https://executor.rodent.cc/mcp";
            enabled = true;
          };
        };
      };
    };
  };
}
