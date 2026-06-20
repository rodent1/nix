{
  callPackage,
  lib,
  stdenv,
  installShellFiles,
}:
let
  sourceData = callPackage _sources/generated.nix { };
in
stdenv.mkDerivation {
  inherit (sourceData.flate) pname src version;

  nativeBuildInputs = [
    installShellFiles
  ];

  sourceRoot = ".";
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    install -D -m0755 flate $out/bin/flate

    runHook postInstall
  '';

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd flate \
      --bash <($out/bin/flate completion bash) \
      --fish <($out/bin/flate completion fish) \
      --zsh <($out/bin/flate completion zsh)
  '';

  meta = {
    description = "Render and diff Flux GitOps repositories fully offline";
    homepage = "https://github.com/home-operations/flate";
    license = lib.licenses.agpl3Only;
    mainProgram = "flate";
  };
}
