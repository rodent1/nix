{ lib, ... }:
{
  options.internal = {
    nixosModules = lib.mkOption {
      type = lib.types.lazyAttrsOf lib.types.deferredModule;
      default = { };
    };

    homeModules = lib.mkOption {
      type = lib.types.lazyAttrsOf lib.types.deferredModule;
      default = { };
    };

    hosts = lib.mkOption {
      type = lib.types.lazyAttrsOf (
        lib.types.submodule {
          options = {
            system = lib.mkOption {
              type = lib.types.str;
            };
            isWSL = lib.mkOption {
              type = lib.types.bool;
              default = false;
            };
          };
        }
      );
      default = { };
    };

    packageRecipes = lib.mkOption {
      type = lib.types.lazyAttrsOf lib.types.path;
      default = { };
    };

    overlays = {
      aliases = lib.mkOption {
        type = lib.types.unspecified;
        default = final: prev: { };
      };
      unstable = lib.mkOption {
        type = lib.types.unspecified;
        default = final: prev: { };
      };
    };
  };
}
