{ inputs, ... }:
let
  homeManagerLib = import ./homemanager.nix { inherit inputs; };
  overlayModule = import ../../overlays { inherit inputs; };
in
{
  mkBaseSystem =
    {
      system,
      hostname,
      systemFunction,
      modules ? [ ],
    }:
    let
      overlays = (overlayModule.perSystem { inherit system; })._module.args.overlays;
      pkgs = import inputs.nixpkgs { inherit system overlays; };
    in
    systemFunction {
      inherit system;
      modules = [
        {
          nixpkgs = {
            inherit overlays;
            hostPlatform = system;
            config.allowUnfree = true;
          };
          _module.args = {
            inherit inputs system;
          };
        }
        { home-manager = homeManagerLib.mkHomeManagerConfig { inherit hostname system pkgs; }; }
        ../../hosts/_modules/common
      ] ++ modules;
      specialArgs = {
        inherit inputs hostname;
      };
    };
}
