{
  config,
  isWSL,
  lib,
  ...
}:
{
  config = {
    xdg.configFile."1Password/ssh/agent.toml" = lib.mkIf (!isWSL) {
      text = ''
        [[ssh-keys]]
        item = "Personal"
        vault = "dotfiles"
      '';
    };

    home.sessionVariables = lib.mkIf (!isWSL) {
      SSH_AUTH_SOCK = "${config.home.homeDirectory}/.1password/agent.sock";
    };

    programs.fish.loginShellInit = lib.mkIf isWSL ''
      set -gx OP_SERVICE_ACCOUNT_TOKEN (cat ${config.xdg.configHome}/1Password/op-service-account-token)
    '';
  };
}
