{
  inputs,
  self,
  ...
}:
let
  hostsLib = import ./_lib.nix { inherit inputs self; };
in
{
  flake.nixosConfigurations.laptop = hostsLib.mkNixosHost {
    hostname = "laptop";
    hostModule = ../../hosts/laptop;
  };
}
