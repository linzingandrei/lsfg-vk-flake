{
  lib,
  fetchFromGitHub,
  cmake,
  vulkan-headers,
  llvmPackages,
}:

llvmPackages.stdenv.mkDerivation rec {
  pname = "lsfg-vk";
  version = "2.0.0-dev";

  src = fetchFromGitHub {
    owner = "PancakeTAS";
    repo = "lsfg-vk";
    tag = "v${version}";
    hash = "sha256-Qb3vufCzNpM1r+vgo8M9nnA7CENgGTithWG0oXqLKbI=";
    fetchSubmodules = true;
  };

  installPhase = ''
    runHook preInstall

    find . -name "VkLayer_LSFGVK_frame_generation.json"

    install -Dm755 lsfg-vk-cli/lsfg-vk-cli $out/bin/lsfg-vk-cli

    install -Dm644 lsfg-vk-layer/VkLayer_LSFGVK_frame_generation.json \
        $out/share/vulkan/implicit_layer.d/VkLayer_LSFGVK_frame_generation.json

    install -Dm755 lsfg-vk-layer/liblsfg-vk-layer.so \
        $out/lib/liblsfg-vk-layer.so

    runHook postInstall
  '';

  postInstall = ''
    substituteInPlace \
        $out/share/vulkan/implicit_layer.d/VkLayer_LSFGVK_frame_generation.json \
        --replace-fail \
        "liblsfg-vk-layer.so" \
        "$out/lib/liblsfg-vk-layer.so"
  '';

  nativeBuildInputs = [
    llvmPackages.clang-tools
    llvmPackages.libllvm
    cmake
  ];

  buildInputs = [
    vulkan-headers
  ];

  meta = {
    description = "Vulkan layer for frame generation (Requires owning Lossless Scaling)";
    homepage = "https://github.com/PancakeTAS/lsfg-vk/";
    changelog = "https://github.com/PancakeTAS/lsfg-vk/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ pabloaul ];
  };
}
