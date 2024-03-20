{ inputs, outputs, config, pkgs ? import <nixpkgs> {} , lib, ... }:

let 
  # shell color: diff typr of file will have diff color
  # b = pkgs.callPackage ./src/b {};
  user = "jacky";
  domain = "DDebian"; 
  enableNixDev = true;
  enableClashProxy = true;
in
{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.

  imports = [
    (import ../../profile/comm.nix { inherit user domain inputs outputs enableClashProxy; })
    (import ../../profile/base-devel.nix { inherit pkgs inputs enableNixDev; })
  ];

  home.packages = with pkgs; [
    # jq        # ?
    # rnix-lsp  # lsp support of nix
    # xclip     # using for neovim clipboard
    # zola      # blog

    # personal packages
    zotero
    adobe-reader
    mendeley

    # nerdfonts
    # https://github.com/NixOS/nixpkgs/blob/nixos-23.11/pkgs/data/fonts/nerdfonts/shas.nix
    (nerdfonts.override {
      fonts = [
        # symbols icon only
        "NerdFontsSymbolsOnly"
        # Characters
        "FiraCode"
        "JetBrainsMono"
        "Iosevka"
      ];
    })
  ];

  nixpkgs.config.permittedInsecurePackages = [
    "adobe-reader-9.5.5"
  ];



  # terminal 
  programs = {
    bat = {
      enable = true;
      config = {
        # theme = "ansi-dark";
        theme = "base16-256";
      };
    };
    command-not-found.enable = true;
  };

  fonts.fontconfig.enable = true;

}
