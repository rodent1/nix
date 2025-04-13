{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.modules.shell.gh;
in
{
  options.modules.shell.gh = {
    enable = lib.mkEnableOption "gh";
  };

  config = lib.mkIf cfg.enable {
    programs.gh = {
      enable = true;
      extensions =
        with pkgs;
        [
          gh-tidy
        ]
        ++ [ pkgs.unstable.gh-copilot ];
    };
  };
}
