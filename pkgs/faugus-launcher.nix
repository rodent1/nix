{
  fetchFromGitHub,
  gobject-introspection,
  icoextract,
  imagemagick,
  lib,
  libayatana-appindicator,
  libcanberra-gtk3,
  lsfg-vk,
  meson,
  ninja,
  nix-update-script,
  python3Packages,
  umu-launcher,
  wrapGAppsHook3,
  xdg-utils,
}:

python3Packages.buildPythonApplication rec {
  pname = "faugus-launcher";
  version = "1.17.5";
  pyproject = false;

  src = fetchFromGitHub {
    owner = "Faugus";
    repo = "faugus-launcher";
    tag = version;
    hash = "sha256-MnQ9s8IwwLVl/HZROe10TEL4sh8qbqU3J6V2Os4zBIU=";
  };

  nativeBuildInputs = [
    gobject-introspection
    meson
    ninja
    wrapGAppsHook3
  ];

  buildInputs = [
    libayatana-appindicator
  ];

  dependencies = with python3Packages; [
    pillow
    psutil
    pygobject3
    requests
    vdf
  ];

  postPatch = ''
    substituteInPlace faugus-launcher \
      --replace-fail "python3" "${python3Packages.python.interpreter}"

    substituteInPlace faugus/launcher.py \
      --replace-fail "PathManager.user_data('faugus-launcher/umu-run')" "'${lib.getExe umu-launcher}'" \
      --replace-fail "/usr/lib/extensions/vulkan/lsfgvk/lib/liblsfg-vk.so" "${lsfg-vk}/lib/liblsfg-vk.so" \
      --replace-fail "/usr/lib/liblsfg-vk.so" "${lsfg-vk}/lib/liblsfg-vk.so"

    substituteInPlace faugus/runner.py \
      --replace-fail "PathManager.user_data('faugus-launcher/umu-run')" "'${lib.getExe umu-launcher}'"

    substituteInPlace faugus/shortcut.py \
      --replace-fail "/usr/lib/extensions/vulkan/lsfgvk/lib/liblsfg-vk.so" "${lsfg-vk}/lib/liblsfg-vk.so" \
      --replace-fail "/usr/lib/liblsfg-vk.so" "${lsfg-vk}/lib/liblsfg-vk.so"
  '';

  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs+=(
      "''${gappsWrapperArgs[@]}"
      --suffix PYTHONPATH : "$out/${python3Packages.python.sitePackages}:$PYTHONPATH"
      --suffix PATH : "${
        lib.makeBinPath [
          icoextract
          imagemagick
          libcanberra-gtk3
          umu-launcher
          xdg-utils
        ]
      }"
    )
    wrapProgram $out/bin/faugus-launcher ''${makeWrapperArgs[@]}
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Simple and lightweight app for running Windows games using UMU-Launcher";
    homepage = "https://github.com/Faugus/faugus-launcher";
    changelog = "https://github.com/Faugus/faugus-launcher/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ RoGreat ];
    mainProgram = "faugus-launcher";
    platforms = lib.platforms.linux;
  };
}
