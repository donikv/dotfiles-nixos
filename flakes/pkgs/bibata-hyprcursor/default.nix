{
  lib,
  stdenvNoCC,
  fetchurl,
  bibata-cursors,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "bibata-hyprcursor";

  inherit (bibata-cursors) version;

  src = fetchurl {
    url = "https://github.com/ful1e5/Bibata_Cursor/releases/download/v2.0.7/Bibata-Modern-Classic.tar.xz";
    name = "HyprBibataModernClassic.tar.gz";
    hash = "sha256-fTSVhk5bvvAvXnfedgspBZA7Y8cUlaeO9jBtGaO1Vtg=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/icons
    cp -r $PWD $out/share/icons

    runHook postInstall
  '';

  meta = {
    description = "Open source, compact, and material designed cursor set";
    homepage = "https://github.com/LOSEARDES77/Bibata-Cursor-hyprcursor";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [fufexan];
  };
})
