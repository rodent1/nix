{
  lib,
  config,
  ...
}:
let
  cfg = config.modules.editor.vscode-server-fix;
in
{
  options.modules.editor.vscode-server-fix = {
    enable = lib.mkEnableOption "vscode-server-fix";
  };

  config = lib.mkIf (cfg.enable) ({
    home.file = {
      vscode-server-fix = {
        target = ".vscode-server/server-env-setup";
        text = ''
          # Make sure that basic commands are available
          PATH=$PATH:/run/current-system/sw/bin/
        '';
      };
    };
  });
}
