{
  internal.homeModules.default =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    let
      cfg = config.modules.development.opencode;
    in
    {
      options.modules.development.opencode = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = config.modules.development.enable;
          description = "Enable OpenCode";
        };
      };

      config = lib.mkIf cfg.enable {
        programs.opencode = {
          enable = true;
          package = pkgs.unstable.opencode;

          enableMcpIntegration = true;

          settings = {
            formatter = true;
            lsp = true;
          };
        };

        xdg.configFile."fish/completions/opencode.fish".text = ''
          function __opencode_completions
              set -l args (commandline -opc)
              set -e args[1]
              set -l results (opencode --get-yargs-completions $args 2>/dev/null | grep -v '^\$0$')
              if test (count $results) -eq 0
                  __fish_complete_path (commandline -ct)
              else
                  printf '%s\n' $results
              end
          end

          complete -c opencode -f -a '(__opencode_completions)'
        '';
      };
    };
}
