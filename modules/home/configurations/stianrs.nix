{
  inputs,
  self,
  withSystem,
  ...
}:
let
  homeLib = import ../_lib.nix {
    inherit inputs self withSystem;
  };
in
{
  flake.homeConfigurations = {
    gamer = homeLib.mkHomeConfiguration {
      hostname = "gamer";
    };

    laptop = homeLib.mkHomeConfiguration {
      hostname = "laptop";
    };

    work = homeLib.mkHomeConfiguration {
      hostname = "work";
      isWSL = true;
    };
  };
}
