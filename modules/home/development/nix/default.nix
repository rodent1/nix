{
  internal.homeModules.default =
    {
      pkgs,
      ...
    }:
    {
      config = {
        home.packages = with pkgs; [
          deadnix
          nix-init
          nix-inspect
          nixd
          nixfmt
          nvfetcher
          statix
        ];
      };
    };
}
