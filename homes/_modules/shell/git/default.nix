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
  };

  config = lib.mkIf cfg.enable {
    programs.gpg.enable = true;

    programs.git = {
      enable = true;

      userName = cfg.username;
      userEmail = cfg.email;

      extraConfig = {
        core = {
          autocrlf = "input";
        };
        init = {
          defaultBranch = "main";
        };
        pull = {
          rebase = true;
        };
        rebase = {
          autoStash = true;
        };
        gpg = {
          format = "ssh";
        };
      };
      aliases = {
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
      signing = {
        signByDefault = true;
        key = cfg.signingKey;
      };
    };

    home.packages = [
      pkgs.git-filter-repo
      pkgs.tig
    ];
  };
}
