{ lib, ... }:
{
  imports = [
    ./go
    ./nix
    ./python
    ./rust
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
