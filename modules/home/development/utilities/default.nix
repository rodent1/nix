{
  internal.homeModules.default =
    {
      pkgs,
      ...
    }:
    {
      config = {
        home.packages = with pkgs; [
          act
          bubblewrap
          gnumake
          gcc
          pkg-config
          shellcheck
          shfmt
        ];
      };
    };
}
