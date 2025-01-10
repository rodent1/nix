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
        inputs.catppuccin.homeManagerModules.catppuccin
        inputs.krewfile.homeManagerModules.krewfile
        inputs.nix-index-database.hmModules.nix-index
        inputs.nixvim.homeManagerModules.nixvim
        inputs.sops-nix.homeManagerModules.sops
      ];
      extraSpecialArgs = {
        inherit inputs hostname system;
      };
      users.stianrs = ../../. + "/homes/stianrs";
    };
}
