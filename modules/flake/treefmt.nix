{ inputs, ... }:
{
  imports = [
    inputs.treefmt-nix.flakeModule
  ];

  perSystem =
    { ... }:
    {
      treefmt.config = {
        projectRootFile = "flake.nix";
        flakeCheck = true;
        programs.nixfmt.enable = true;

        settings = {
          global.excludes = [
            "**/hardware-configuration.nix"
            "pkgs/_sources/*"
          ];
        };
      };
    };
}
