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
  inherit (sourceData.gh-fish) pname src;
  version = sourceData.gh-fish.date;

  dontConfigure = true;
  dontBuild = true;
  buildInputs = [ pkgs.git ];

  installPhase = ''
    mkdir -p $out/bin
    cp gh-fish $out/bin
    cp gh-copilot-alias.fish $out/bin
  '';

  meta = with lib; {
    description = "A gh extension to tidy up your GitHub repositories";
    homepage = "https://github.com/DevAtDawn/gh-fish";
    license = licenses.publicDomain;
    platforms = platforms.unix;
    maintainers = with maintainers; [ rodent1 ];
    mainProgram = "gh-fish";
  };
}
