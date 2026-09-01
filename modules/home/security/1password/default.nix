{
  internal.homeModules.default =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      config = {
        xdg.configFile."1Password/ssh/agent.toml" = lib.mkIf (!config.host.isWSL) {
          text = ''
            [[ssh-keys]]
            item = "Personal"
            vault = "dotfiles"
          '';
        };

        home.sessionVariables = lib.mkIf (!config.host.isWSL) {
          SSH_AUTH_SOCK = "${config.home.homeDirectory}/.1password/agent.sock";
        };

        programs.fish.functions.op = lib.mkIf config.host.isWSL {
          body = ''
            env OP_SERVICE_ACCOUNT_TOKEN="$(cat ${config.xdg.configHome}/1Password/op-service-account-token)" ${pkgs._1password-cli}/bin/op $argv
          '';
        };

        programs.fish.shellAliases = lib.mkIf config.host.isWSL {
          ssh = "ssh.exe";
          "ssh-add" = "ssh-add.exe";
        };

        programs.git.settings = lib.mkIf config.host.isWSL {
          core.sshCommand = "ssh.exe";
          gpg.ssh.program = "op-ssh-sign-wsl.exe";
        };
      };
    };
}
