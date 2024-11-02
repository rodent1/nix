{ inputs, ... }:
{
  mkHomeManagerConfig =
    {
      hostname,
      system,
      pkgs,
    }:
    {
      useUserPackages = true;
      useGlobalPkgs = true;
      sharedModules = [
        {
          nixpkgs = {
            config = {
              allowUnfree = true;
              inherit pkgs;
            };
          };
        }
        inputs.krewfile.homeManagerModules.krewfile
        inputs.catppuccin.homeManagerModules.catppuccin
        inputs.sops-nix.homeManagerModules.sops
      ];
      extraSpecialArgs = {
        inherit inputs hostname system;
      };
      users.stianrs = ../../. + "/homes/stianrs";
    };
}
