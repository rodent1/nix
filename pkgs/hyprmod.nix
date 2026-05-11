{
  callPackage,
  fetchPypi,
  gobject-introspection,
  glib,
  gtk4,
  lib,
  libadwaita,
  wrapGAppsHook4,
  python3Packages,
}:
let
  sourceData = callPackage ./_sources/generated.nix { };

  hyprland-config = python3Packages.buildPythonPackage rec {
    pname = "hyprland-config";
    version = "0.4.5";
    pyproject = true;

    src = fetchPypi {
      pname = "hyprland_config";
      inherit version;
      hash = "sha256-8wtIhqlm03LhM0Ij7BYAu04/Ppz8B11K9vQJu1dBMt0=";
    };

    build-system = with python3Packages; [ hatchling ];

    pythonImportsCheck = [ "hyprland_config" ];

    meta = {
      description = "Round-trip parser and editor for Hyprland configuration files";
      homepage = "https://github.com/BlueManCZ/hyprland-config";
      license = lib.licenses.mit;
      platforms = lib.platforms.linux;
    };
  };

  hyprland-schema = python3Packages.buildPythonPackage rec {
    pname = "hyprland-schema";
    version = "0.5.0";
    pyproject = true;

    src = fetchPypi {
      pname = "hyprland_schema";
      inherit version;
      hash = "sha256-NVQtwN3y/5TirutEwaLWTtCRNzoqDR3QYSQuaKUsxHU=";
    };

    build-system = with python3Packages; [ hatchling ];

    pythonImportsCheck = [ "hyprland_schema" ];

    meta = {
      description = "Typed Python schema for every Hyprland configuration option";
      homepage = "https://github.com/BlueManCZ/hyprland-schema";
      license = lib.licenses.mit;
      platforms = lib.platforms.linux;
    };
  };

  hyprland-socket = python3Packages.buildPythonPackage rec {
    pname = "hyprland-socket";
    version = "0.10.0";
    pyproject = true;

    src = fetchPypi {
      pname = "hyprland_socket";
      inherit version;
      hash = "sha256-X2bvextOZHQrf00G0EqRjsDJJkCqOtP1s4N7laRC4So=";
    };

    build-system = with python3Packages; [ hatchling ];

    pythonImportsCheck = [ "hyprland_socket" ];

    meta = {
      description = "Typed Python library for Hyprland IPC via Unix sockets";
      homepage = "https://github.com/BlueManCZ/hyprland-socket";
      license = lib.licenses.mit;
      platforms = lib.platforms.linux;
    };
  };

  hyprland-monitors = python3Packages.buildPythonPackage rec {
    pname = "hyprland-monitors";
    version = "0.5.0";
    pyproject = true;

    src = fetchPypi {
      pname = "hyprland_monitors";
      inherit version;
      hash = "sha256-HizQ9wwwXzB79XtAjQ7/2cMt9z0rSyoBhKdxghf09oM=";
    };

    build-system = with python3Packages; [ hatchling ];

    propagatedBuildInputs = [
      hyprland-socket
    ];

    pythonImportsCheck = [ "hyprland_monitors" ];

    meta = {
      description = "Monitor management utilities for Hyprland";
      homepage = "https://github.com/BlueManCZ/hyprland-monitors";
      license = lib.licenses.mit;
      platforms = lib.platforms.linux;
    };
  };

  hyprland-state = python3Packages.buildPythonPackage rec {
    pname = "hyprland-state";
    version = "0.2.1";
    pyproject = true;

    src = fetchPypi {
      pname = "hyprland_state";
      inherit version;
      hash = "sha256-YI7AuMesHlGTlo11N79GW+UHq4D75Hb8iNEJy2gcdI0=";
    };

    build-system = with python3Packages; [ hatchling ];

    propagatedBuildInputs = [
      hyprland-config
      hyprland-monitors
      hyprland-schema
      hyprland-socket
    ];

    pythonImportsCheck = [ "hyprland_state" ];

    meta = {
      description = "Live state interface for Hyprland";
      homepage = "https://github.com/BlueManCZ/hyprland-state";
      license = lib.licenses.mit;
      platforms = lib.platforms.linux;
    };
  };
in
python3Packages.buildPythonApplication {
  pname = "hyprmod";
  version = lib.removePrefix "v" sourceData.hyprmod.version;
  inherit (sourceData.hyprmod) src;
  pyproject = true;

  nativeBuildInputs = [
    gobject-introspection
    glib
    wrapGAppsHook4
  ];

  buildInputs = [
    gtk4
    libadwaita
  ];

  build-system = with python3Packages; [ hatchling ];

  pythonRelaxDeps = true;
  pythonRemoveDeps = [
    "pygobject"
    "hyprland-config"
    "hyprland-schema"
    "hyprland-state"
    "hyprland-monitors"
    "hyprland-socket"
  ];

  dependencies = [
    python3Packages.pygobject3
    hyprland-config
    hyprland-schema
    hyprland-state
    hyprland-monitors
    hyprland-socket
  ];

  pythonImportsCheck = [ "hyprmod" ];

  meta = {
    description = "Native GTK4/libadwaita settings app for Hyprland";
    homepage = "https://github.com/BlueManCZ/hyprmod";
    changelog = "https://github.com/BlueManCZ/hyprmod/releases/tag/${sourceData.hyprmod.version}";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    mainProgram = "hyprmod";
  };
}
