{
  callPackage,
  appimageTools,
}:
let
  sourceData = callPackage _sources/generated.nix { };
in
appimageTools.wrapType2 rec {
  inherit (sourceData.wagoapp) pname version src;
  appimageContents = appimageTools.extract { inherit pname version src; };

  extraInstallCommands = ''
    install -m 444 -D ${appimageContents}/WagoApp.desktop $out/share/applications/WagoApp.desktop
    install -m 444 -D ${appimageContents}/WagoApp.png $out/share/icons/hicolor/512x512/apps/WagoApp.png
    substituteInPlace $out/share/applications/WagoApp.desktop --replace-fail 'Exec=AppRun' 'Exec=${pname}'
  '';
}
