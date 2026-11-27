{
  callPackage,
  lib,
  stdenv,
  autoPatchelfHook,
  makeWrapper,
  wrapGAppsHook3,
  alsa-lib,
  fontconfig,
  gtk3,
  libarchive,
  libepoxy,
  libGL,
  libsecret,
  libsoup_3,
  mpv-unwrapped,
  sqlite,
  webkitgtk_4_1,
  xdg-user-dirs,
}:
let
  sourceData = callPackage ../_sources/generated.nix { };
in
# Upstream's system-libs build bundles only the Flutter engine and plugins and
# expects everything else from the host, which nixpkgs supplies here.
stdenv.mkDerivation {
  inherit (sourceData.moonfin) pname src version;

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
    wrapGAppsHook3
  ];

  buildInputs = [
    alsa-lib
    fontconfig
    gtk3
    libarchive
    libepoxy
    libsecret
    libsoup_3
    mpv-unwrapped
    stdenv.cc.cc
    webkitgtk_4_1
  ];

  # Dart FFI dlopens libsqlite3, and libepoxy dlopens the GL/EGL driver.
  runtimeDependencies = [
    libGL
    (lib.getLib sqlite)
  ];

  # libdartjni only serves Android JNI and never loads on Linux.
  autoPatchelfIgnoreMissingDeps = [ "libjvm.so" ];

  dontBuild = true;
  dontWrapGApps = true;

  # Flutter resolves lib/ and data/ next to the executable, so the bundle stays
  # together. Upstream's `moonfin` launcher only checks for missing host
  # libraries, which the patched RUNPATHs make unnecessary.
  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/moonfin
    cp -r lib data $out/lib/moonfin/
    install -m0755 moonfin-bin $out/lib/moonfin/moonfin
    cp -r share $out/share

    runHook postInstall
  '';

  postFixup = ''
    makeWrapper $out/lib/moonfin/moonfin $out/bin/moonfin \
      "''${gappsWrapperArgs[@]}" \
      --prefix PATH : ${lib.makeBinPath [ xdg-user-dirs ]}
  '';

  meta = {
    description = "Jellyfin and Emby media client";
    homepage = "https://github.com/Moonfin-Client/Moonfin-Core";
    license = lib.licenses.gpl3Plus;
    mainProgram = "moonfin";
    platforms = [ "x86_64-linux" ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
}
