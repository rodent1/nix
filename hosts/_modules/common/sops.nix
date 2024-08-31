{ inputs, pkgs, ... }:
{
  imports = [ inputs.sops-nix.nixosModules.sops ];

  config = {
    environment.systemPackages = [
      pkgs.sops
      pkgs.age
    ];

    sops = {
      age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
    };
  };
}
