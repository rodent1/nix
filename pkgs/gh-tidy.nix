{
  callPackage,
  lib,
  pkgs,
  stdenvNoCC,
}:
let
  sourceData = callPackage _sources/generated.nix { };
in
stdenvNoCC.mkDerivation {
  inherit (sourceData.gh-tidy) pname src;
  version = sourceData.gh-tidy.date;

  dontConfigure = true;
  dontBuild = true;
  buildInputs = [ pkgs.git ];

  installPhase = ''
    mkdir -p $out/bin
    cp gh-tidy $out/bin
  '';

  meta = with lib; {
    description = "A gh extension to tidy up your GitHub repositories";
    homepage = "https://github.com/HaywardMorihara/gh-tidy";
    license = licenses.publicDomain;
    platforms = platforms.unix;
    maintainers = with maintainers; [ rodent1 ];
    mainProgram = "gh-tidy";
  };
}
