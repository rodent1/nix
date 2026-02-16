{
  config,
  isWSL,
  lib,
  ...
}:
{
  config =
    lib.mkIf (!isWSL) {
      xdg.configFile."1Password/ssh/agent.toml" = {
        text = ''
          [[ssh-keys]]
          item = "Personal"
          vault = "dotfiles"
        '';
      };

      home.sessionVariables = {
        SSH_AUTH_SOCK = "${config.home.homeDirectory}/.1password/agent.sock";
      };
    }
    // lib.mkIf isWSL {
      programs.fish.loginShellInit = ''
        set -gx OP_SERVICE_ACCOUNT_TOKEN (cat ${config.xdg.configHome}/1password/op-service-account-token)
      '';
    };
}
