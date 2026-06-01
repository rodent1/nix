{ lib, ... }:
{
  flake.homeModules.development = {
    imports = [
      ./development/_modules/go.nix
      ./development/_modules/nix.nix
      ./development/_modules/python.nix
      ./development/_modules/utilities.nix
      ./development/_modules/web.nix
    ];

    options.modules.development = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Enable development tools and utilities.";
      };
    };
  };
}
