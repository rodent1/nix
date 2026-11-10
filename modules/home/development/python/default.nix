{
  internal.homeModules.default =
    {
      pkgs,
      ...
    }:
    {
      config = {
        home.packages = with pkgs; [
          python3
          ruff
          uv
        ];
      };
    };
}
