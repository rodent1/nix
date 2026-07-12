{
  internal.homeModules.default =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.modules.development.agent-browser;
      agent-browser = pkgs.writeShellApplication {
        name = "agent-browser";
        runtimeInputs = [ pkgs.chromium ];
        text = ''
          # Use Nixpkgs Chromium rather than downloading Chrome at runtime.
          export AGENT_BROWSER_EXECUTABLE_PATH="${lib.getExe pkgs.chromium}"
          exec ${lib.getExe pkgs.agent-browser} "$@"
        '';
      };
    in
    {
      options.modules.development.agent-browser = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = config.modules.development.enable;
          description = "Enable agent-browser";
        };
      };

      config = lib.mkIf cfg.enable {
        home.packages = [ agent-browser ];
      };
    };
}
