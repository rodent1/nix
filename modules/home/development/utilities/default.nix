{
  internal.homeModules.default =
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
          gnumake
          gcc
          unstable.oxfmt
          pkg-config
          shellcheck
          shfmt
        ];
      };
    };
}
