{
  callPackage,
  lib,
  stdenv,
}:
let
  sourceData = callPackage _sources/generated.nix { };
in
stdenv.mkDerivation {
  inherit (sourceData.kubectl-kopiur) pname src version;

  sourceRoot = ".";
  dontBuild = true;

  installPhase = ''
    runHook preInstall

      install -D -m0755 kopiur $out/bin/kubectl-kopiur

    runHook postInstall
  '';

  meta = {
    description = "Operate the kopiur backup operator";
    homepage = "https://github.com/home-operations/kopiur";
    license = lib.licenses.agpl3Only;
    mainProgram = "kubectl-kopiur";
  };
}
