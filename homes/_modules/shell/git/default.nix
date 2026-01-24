{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.modules.shell.git;
in
{
  options.modules.shell.git = {
    enable = lib.mkEnableOption "git";
    username = lib.mkOption { type = lib.types.str; };
    email = lib.mkOption { type = lib.types.str; };
    signingKey = lib.mkOption { type = lib.types.str; };
    gh = lib.mkOption {
      type = lib.types.bool;
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    programs.gpg.enable = true;

    programs.git = {
      enable = true;

      signing = {
        signByDefault = true;
        format = "ssh";
        key = cfg.signingKey;
      };

      ignores = [
        # Mac OS X hidden files
        ".DS_Store"
        # Windows files
        "Thumbs.db"
        # asdf
        ".tool-versions"
        # Sops
        ".decrypted~*"
        "*.decrypted.*"
        # Python virtualenvs
        ".venv"
        # Direnv files
        ".direnv"
      ];

      settings = {
        alias = {
          a = "add";
          c = "commit";
          ca = "commit --amend";
          cm = "commit --message";
          co = "checkout";
          d = "diff";
          l = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
          pl = "pull --rebase --autostash --prune";
          rpo = "remote prune origin";
          s = "status -sb";
        };

        core = {
          autocrlf = "input";
        };
        init = {
          defaultBranch = "main";
        };
        fetch = {
          prune = true;
        };
        merge = {
          summary = true;
          verbosity = "1";
        };
        gpg = {
          format = "ssh";
        };
        push = {
          autosetupremote = true;
          default = "current";
        };
        rebase = {
          autoStash = true;
        };

        user = {
          name = cfg.username;
          email = cfg.email;
        };
      };

    };

    programs.gh = lib.mkIf cfg.gh {
      enable = true;
      package = pkgs.unstable.gh;
    };
  };
}
