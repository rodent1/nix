{
  inputs,
  self,
  ...
}:
let
  hostsLib = import ./_lib.nix { inherit inputs self; };
in
{
  flake.nixosConfigurations.gamer = hostsLib.mkNixosHost {
    hostname = "gamer";
    hostModule = ../../hosts/gamer;
  };
}
