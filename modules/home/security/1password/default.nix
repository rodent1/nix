{
  rodent.homeModules.default =
    {
      config,
      lib,
      pkgs,
      ...
    }:
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

        programs.fish.functions.op = lib.mkIf config.rodent.isWSL {
          body = ''
            env OP_SERVICE_ACCOUNT_TOKEN="$(cat ${config.xdg.configHome}/1Password/op-service-account-token)" ${pkgs._1password-cli}/bin/op $argv
          '';
        };
      };
    };
}
