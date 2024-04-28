{...}: {
  imports = [./ssh-relay];
  modules = {
    deployment.nix.enable = true;
    development.enable = true;
    kubernetes.enable = true;
  };
}
