{ lib, ... }:
{
  flake.homeModules.development = {
    imports = [
      ../../homes/_modules/development/go
      ../../homes/_modules/development/nix
      ../../homes/_modules/development/python
      ../../homes/_modules/development/utilities
      ../../homes/_modules/development/web
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
