{
  rodent.hosts.work = {
    system = "x86_64-linux";
    isWSL = true;
  };

  rodent.nixosModules.work = _: {
    imports = [ ./work/_hardware/default.nix ];
  };
}
