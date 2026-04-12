{
  stdenvNoCC,
  appimageTools,
  fetchurl,
}:

let
  pname = "wago";
  version = "2.9.10";
  src = fetchurl {
    url = "https://wago-addons.ams3.digitaloceanspaces.com/wagoapp/WagoApp_${version}.AppImage";
    hash = "sha256-phVLBo17cddZd+LDICXvqsuRm2k5gJSx0BOlC2oHZXk=";
  };
  appimage = appimageTools.wrapType2 {
    inherit pname version src;
  };
  appimageContents = appimageTools.extractType2 {
    inherit pname version src;
  };
in

stdenvNoCC.mkDerivation {
  inherit pname version;

  src = appimage;

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -r bin $out/bin

    mkdir -p $out/share/${pname}
    cp -a ${appimageContents}/locales $out/share/${pname}
    cp -a ${appimageContents}/resources $out/share/${pname}
    cp -a ${appimageContents}/usr/share/icons $out/share
    install -Dm 644 ${appimageContents}/WagoApp.desktop -T $out/share/applications/wago.desktop

    substituteInPlace $out/share/applications/wago.desktop --replace "AppRun" "${pname}"

    runHook postInstall
  '';
}
