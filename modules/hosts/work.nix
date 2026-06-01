{
  inputs,
  self,
  ...
}:
let
  hostsLib = import ./_lib.nix { inherit inputs self; };
in
{
  flake.nixosConfigurations.work = hostsLib.mkWslHost {
    hostname = "work";
    hostModule = ../../hosts/work;
  };
}
