{ lib, ... }:
{
  imports = [
    ./go
    ./nix
    ./python
    ./utilities
    ./web
  ];

  options.modules.development = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable development tools and utilities.";
    };
  };
}
