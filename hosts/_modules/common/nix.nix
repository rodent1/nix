{ inputs, lib, ... }:
{
  nix = {
    settings = {
      trusted-substituters = [
        "https://nix-community.cachix.org"
        "https://cache.garnix.io"
        "https://rodent1.cachix.org"
      ];

      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
        "rodent1.cachix.org-1:iM76vQ3wmww8gwBdPIoHIoFIem83qv6v0gxytvHA3lk="
      ];

      # Fallback quickly if substituters are not available.
      connect-timeout = 5;

      # Enable flakes
      experimental-features = [
        "nix-command"
        "flakes"
      ];

      warn-dirty = false;

      # The default at 10 is rarely enough.
      log-lines = lib.mkDefault 25;

      # Avoid disk full issues
      max-free = lib.mkDefault (1000 * 1000 * 1000);
      min-free = lib.mkDefault (128 * 1000 * 1000);

      # Avoid copying unnecessary stuff over SSH
      builders-use-substitutes = true;
    };

    # Add nixpkgs input to NIX_PATH
    nixPath = [ "nixpkgs=${inputs.nixpkgs.outPath}" ];
  };
}
