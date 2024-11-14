{ pkgs, ... }: let
  rime-ice-pkgs = pkgs.callPackage ../modules/home-manager/rime/rime-ice.nix { };

  librime' = pkgs.librime.overrideAttrs (old: {
    postInstall = ''
      mkdir $out/share/rime-data/
      cp -r ${pkgs.rime-data}/share/rime-data/  $out/share/rime-data/ 

      cp -r ${rime-ice-pkgs}/cn_dicts $out/share/rime-data/
      cp ${rime-ice-pkgs}/rime_ice.dict.yaml $out/share/rime-data/
    '';
  });
in {
  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.waylandFrontend = true;
    fcitx5.addons = with pkgs; [
      fcitx5-gtk
      # fcitx5-rime
      (fcitx5-rime.override {
        librime = librime'; 
        rimeDataPkgs = with pkgs; [ 
          rime-data 
          (callPackage ../modules/home-manager/rime/rime-ice.nix { })
        ];
      })
      # fcitx5-moegirl NOTE: Stewart86/flakes
      fcitx5-chinese-addons
      fcitx5-table-extra
      # colorscheme
      fcitx5-nord
      fcitx5-rose-pine
    ];
  };
}
