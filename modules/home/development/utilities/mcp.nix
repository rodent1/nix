{
  internal.homeModules.default =
    {
      config,
      lib,
      ...
    }:
    {
      config = lib.mkIf config.modules.development.enable {
        programs.mcp = {
          enable = true;

          servers = {
            executor = {
              type = "remote";
              url = "https://executor.rodent.cc/mcp";
              enabled = true;
            };

            nixos = {
              type = "local";
              command = "uvx";
              args = [ "mcp-nixos" ];
              enabled = true;
            };
          };
        };
      };
    };
}
