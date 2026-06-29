{
  lib,
  fetchFromGitHub,
  stdenv,
  cmake,
  rustPlatform,
  pkg-config,
  qt6,
  mesa,
  libGL,
  libglvnd,
}:

stdenv.mkDerivation rec {
  pname = "lsfg-vk-ui";
  version = "2.0.0-dev";

  src = fetchFromGitHub {
    owner = "PancakeTAS";
    repo = "lsfg-vk";
    tag = "v${version}";
    hash = "sha256-Qb3vufCzNpM1r+vgo8M9nnA7CENgGTithWG0oXqLKbI=";
  };

  sourceRoot = "source";

  cmakeFlags = [ "-DLSFGVK_BUILD_UI=ON" ];

  nativeBuildInputs = [
    cmake
    pkg-config
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtdeclarative
    mesa
    libGL
    libglvnd
  ];

  meta = {
    description = "Graphical configuration interface for lsfg-vk";
    homepage = "https://github.com/PancakeTAS/lsfg-vk/";
    changelog = "https://github.com/PancakeTAS/lsfg-vk/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ pabloaul ];
    mainProgram = "lsfg-vk-ui";
  };
}
