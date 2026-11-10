# 1Password provides the SSH agent and commit signer. With a desktop session
# the 1Password app runs locally and serves its agent socket; on a WSL host
# the Windows app does, reached through its .exe tools.
{
  internal.nixosModules.default =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      config = lib.mkMerge [
        { programs._1password.enable = true; }

        (lib.mkIf config.modules.desktop.enable {
          programs._1password-gui = {
            enable = true;
            # Certain features, including CLI integration and system authentication support,
            # require enabling PolKit integration on some desktop environments (e.g. Plasma).
            polkitPolicyOwners = [ "stianrs" ];
          };
        })

        (lib.mkIf config.wsl.enable {
          home-manager.users.stianrs =
            { config, ... }:
            {
              programs.onepassword-secrets.secrets.onepassToken = {
                reference = "op://dotfiles/1password/OP_SERVICE_ACCOUNT_TOKEN";
                path = ".config/1Password/op-service-account-token";
                mode = "0600";
              };

              programs.fish.functions.op = {
                body = ''
                  env OP_SERVICE_ACCOUNT_TOKEN="$(cat ${config.xdg.configHome}/1Password/op-service-account-token)" ${pkgs._1password-cli}/bin/op $argv
                '';
              };

              programs.fish.shellAliases = {
                ssh = "ssh.exe";
                "ssh-add" = "ssh-add.exe";
              };

              programs.git.settings = {
                core.sshCommand = "ssh.exe";
                gpg.ssh.program = "op-ssh-sign-wsl.exe";
              };
            };
        })
      ];
    };

  internal.homeModules.desktop =
    { config, ... }:
    {
      xdg.configFile."1Password/ssh/agent.toml".text = ''
        [[ssh-keys]]
        item = "Personal"
        vault = "dotfiles"
      '';

      home.sessionVariables.SSH_AUTH_SOCK = "${config.home.homeDirectory}/.1password/agent.sock";

      modules.security.ssh.settings."*".identityAgent = "~/.1password/agent.sock";
    };
}
