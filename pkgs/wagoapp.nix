{
  appimageTools,
  fetchurl,
}:

let
  pname = "WagoApp";
  version = "2.9.11";
  src = fetchurl {
    url = "https://wago-addons.ams3.digitaloceanspaces.com/wagoapp/WagoApp_${version}.AppImage";
    hash = "sha256-vsRC5Q5nXo//AGf1rZnyiRalX1mQKqhFsbecXml8N30=";
  };
  appimageContents = appimageTools.extract { inherit pname version src; };
in
appimageTools.wrapType2 rec {
  inherit pname version src;

  extraInstallCommands = ''
    install -m 444 -D ${appimageContents}/WagoApp.desktop $out/share/applications/WagoApp.desktop
    install -m 444 -D ${appimageContents}/WagoApp.png $out/share/icons/hicolor/512x512/apps/WagoApp.png
    substituteInPlace $out/share/applications/WagoApp.desktop --replace-fail 'Exec=AppRun' 'Exec=${pname}'
  '';
}
