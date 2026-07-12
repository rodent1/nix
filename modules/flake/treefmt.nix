{ inputs, ... }:
{
  imports = [ inputs.treefmt-nix.flakeModule ];

  perSystem.treefmt.config = {
    projectRootFile = "flake.nix";
    flakeCheck = true;
    programs.nixfmt.enable = true;

    settings.global.excludes = [
      "**/_hardware/**"
      "modules/packages/_sources/*"
    ];
  };
}
