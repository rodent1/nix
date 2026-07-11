{
  rodent.homeModules.default =
    { config, lib, ... }:
    {
      config = {
        xdg.configFile."1Password/ssh/agent.toml" = lib.mkIf (!config.rodent.isWSL) {
          text = ''
            [[ssh-keys]]
            item = "Personal"
            vault = "dotfiles"
          '';
        };

        home.sessionVariables = lib.mkIf (!config.rodent.isWSL) {
          SSH_AUTH_SOCK = "${config.home.homeDirectory}/.1password/agent.sock";
        };

        programs.fish.loginShellInit = lib.mkIf config.rodent.isWSL ''
          set -gx OP_SERVICE_ACCOUNT_TOKEN (cat ${config.xdg.configHome}/1Password/op-service-account-token)
        '';
      };
    };
}
