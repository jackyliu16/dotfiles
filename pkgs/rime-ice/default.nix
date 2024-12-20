# https://github.com/cu1ch3n/nixbook/blob/3b3136fe1f9c7f55258ac08246784193f727c07f/home-manager/programs/rime/rime-ice.nix
{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:
stdenvNoCC.mkDerivation (_: {
  pname = "rime-ice";
  version = "2023-12-02";

  src = fetchFromGitHub {
    owner = "iDvel";
    repo = "rime-ice";
    rev = "bfe1fef6470e01e212b9ba0e0b072ecf5872df77";
    hash = "sha256-YbCAwht4skTGLhpQes0ZyXVgZ8kRwdMLUmUmU7YjMY8=";
  };

  installPhase = ''
    mkdir -p $out/share/rime-data
    cp -r *  $out/share/rime-data
    cp ${./default.yaml} $out/share/rime-data/default.yaml
    # cp ${./default.yaml} $out/share/rime-data/rime_ice_suggestion.yaml
    # cp ${./default.custom.yaml} $out/share/rime-data/default.custom.yaml
  '';

  meta = {
    description = "雾凇拼音，功能齐全，词库体验良好，长期更新修订";
    homepage = "https://github.com/iDvel/rime-ice";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [chen];
  };
})
