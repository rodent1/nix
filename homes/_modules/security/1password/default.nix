{
  config,
  isWSL,
  lib,
  ...
}:
{
  config = lib.mkIf (!isWSL) {
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
  };
}
