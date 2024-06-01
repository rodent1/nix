{...}: {
  imports = [./ssh-relay];
  modules = {
    development.enable = true;
    kubernetes.enable = true;
  };
}
