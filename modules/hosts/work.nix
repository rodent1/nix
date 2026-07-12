{
  internal.hosts.work = {
    system = "x86_64-linux";
    isWSL = true;
  };

  internal.nixosModules.work = _: {
    imports = [ ./_hardware/work.nix ];
  };
}
