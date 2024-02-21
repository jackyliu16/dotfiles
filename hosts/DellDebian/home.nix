{ inputs, outputs, config, pkgs ? import <nixpkgs> {} , lib, ... }:

let 
  # shell color: diff typr of file will have diff color
  # b = pkgs.callPackage ./src/b {};
  user = "jacky";
  domain = "DDebian"; 
  enableNixDev = true;
  enableClash = true;
in
{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.

  imports = [
    (import ../../profile/comm.nix { inherit user domain inputs outputs enableClash; })
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
}
