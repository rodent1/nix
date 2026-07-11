{
  rodent.homeModules.default =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    let
      cfg = config.modules.development;
    in
    {
      config = lib.mkIf cfg.enable {
        home.packages = with pkgs; [
          act
          gcc
          unstable.oxfmt
          unstable.pi-coding-agent
          pkg-config
          shellcheck
          shfmt
        ];
      };
    };
}
