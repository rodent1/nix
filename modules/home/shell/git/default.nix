{
  internal.homeModules.default =
    {
      ...
    }:
    {
      config = {
        programs = {
          gpg.enable = true;

          git = {
            enable = true;

            signing = {
              signByDefault = true;
              format = "ssh";
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
            };

          };

          gh.enable = true;
        };
      };
    };
}
