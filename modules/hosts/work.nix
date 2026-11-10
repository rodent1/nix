{
  internal.hosts.work = {
    system = "x86_64-linux";
  };

  internal.nixosModules.work = _: {
    imports = [ ./_hardware/work.nix ];

    wsl.enable = true;

    home-manager.users.stianrs.modules.kubernetes.enable = false;
  };
}
