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
    enable = lib.mkEnableOption "development";
  };
}
