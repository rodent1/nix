{
  lib,
  stdenv,
  meson,
  ninja,
  pkg-config,
  wrapGAppsHook4,
  glib,
  gtk4,
  gtk4-layer-shell,
  libadwaita,
  wayland,
  wayland-protocols,
  wayland-scanner,
  tesseract4,
  wl-clipboard,
  callPackage,
  nix-update-script,
}:
let
  sourceData = callPackage ../_sources/generated.nix { };
in
stdenv.mkDerivation (finalAttrs: {
  inherit (sourceData.waytator) pname version src;

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wrapGAppsHook4
    glib
    wayland-protocols
    wayland-scanner
  ];

  buildInputs = [
    gtk4
    gtk4-layer-shell
    libadwaita
    wayland
    tesseract4
    wl-clipboard
  ];

  mesonBuildType = "release";

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Screenshot annotator and lightweight image editor";
    homepage = "https://github.com/faetalize/waytator";
    license = licenses.gpl3Plus;
    maintainers = [ ];
    mainProgram = "waytator";
    platforms = platforms.linux;
  };
})
