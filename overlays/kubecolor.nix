final: prev: {
  kubecolor = prev.kubecolor.override {
    buildGoModule = args: prev.buildGoModule (args // {
      meta.mainProgram = "kubecolor";
    });
  };
}
