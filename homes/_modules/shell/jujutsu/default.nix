{
  config,
  lib,
  ...
}:
let
  cfg = config.modules.shell.jujutsu;
in
{
  options.modules.shell.jujutsu = {
    enable = lib.mkEnableOption "jujutsu";
    username = lib.mkOption { type = lib.types.str; };
    email = lib.mkOption { type = lib.types.str; };
    signingKey = lib.mkOption { type = lib.types.str; };
  };

  config = lib.mkIf cfg.enable {
    programs.jujutsu = {
      enable = true;

      settings = {
        user = {
          name = cfg.username;
          email = cfg.email;
        };

        ui = {
          editor = "nvim";
          diff-editor = ":builtin";
          diff-formatter = ":git";
          default-command = "log";
        };

        signing = {
          # Only sign commits authored by you
          behavior = "own";
          # Use SSH keys for commit signing
          backend = "ssh";
          key = cfg.signingKey;
        };
      };
    };
  };
}
