{ inputs, ... }:
{
  rodent.nixosModules.default =
    { lib, ... }:
    let
      substituters = [
        {
          url = "https://cache.nixos.org";
          publicKey = "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=";
          priority = 1;
        }
        {
          url = "https://nix-community.cachix.org";
          publicKey = "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=";
          priority = 2;
        }
        {
          url = "https://nixpkgs-unfree.cachix.org";
          publicKey = "nixpkgs-unfree.cachix.org-1:hqvoInulhbV4nJ9yJOEr+4wxhDV4xq2d1DK7S6Nj6rs=";
          priority = 3;
        }
        {
          url = "https://rodent1.cachix.org";
          publicKey = "rodent1.cachix.org-1:iM76vQ3wmww8gwBdPIoHIoFIem83qv6v0gxytvHA3lk=";
          priority = 4;
        }
      ];
      registryInputs = removeAttrs inputs [ "import-tree" ];
    in
    {
      nix = {
        settings = {
          substituters = builtins.map (def: "${def.url}?priority=${toString def.priority}") substituters;
          trusted-public-keys = builtins.catAttrs "publicKey" substituters;

          # Fallback quickly if substituters are not available.
          connect-timeout = 5;

          # Enable flakes
          experimental-features = [
            "nix-command"
            "flakes"
          ];

          auto-optimise-store = true;

          warn-dirty = false;

          trusted-users = [
            "root"
            "@wheel"
          ];

          # The default at 10 is rarely enough.
          log-lines = lib.mkDefault 25;

          # Avoid disk full issues
          max-free = lib.mkDefault (1000 * 1000 * 1000);
          min-free = lib.mkDefault (128 * 1000 * 1000);

          # Avoid copying unnecessary stuff over SSH
          builders-use-substitutes = true;
        };

        # Add each flake input as a registry
        registry = lib.mapAttrs (_: value: { flake = value; }) registryInputs;

        # Add nixpkgs input to NIX_PATH
        nixPath = [ "nixpkgs=${inputs.nixpkgs.outPath}" ];
      };
    };
}
