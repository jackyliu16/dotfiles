{ inputs, outputs, config, pkgs ? import <nixpkgs> {} , lib, ... }:

let 
  # shell color: diff typr of file will have diff color
  # b = pkgs.callPackage ./src/b {};
  LS_COLORS = pkgs.fetchgit {
    url = "https://github.com/trapd00r/LS_COLORS";
    rev = "09dab448207002624d17f01ed7cbf820aa048063";
    sha256 = "sha256-hQTT/yNS9UIDZqHuul0xmknnOh6tOtfotQIm0SY5TTE=";
  };
  ls-colors = pkgs.runCommand "ls-colors" { } ''
    mkdir -p $out/bin $out/share
    ln -s ${pkgs.coreutils}/bin/ls          $out/bin/ls
    ln -s ${pkgs.coreutils}/bin/dircolors   $out/bin/dircolors
    cp ${LS_COLORS}/LS_COLORS               $out/share/LS_COLORS
  '';
  user = "jacky";
  domain = "DNixOS"; 
  enableNixDev = true;
in
{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.

  imports = [
    (import ../../profile/comm.nix { inherit user domain; })
    (import ../../profile/base-devel.nix { inherit pkgs enableNixDev; })
  ];

  # TODO not sure if working
  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages

      # You can also add overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = (_: true);
    };
  };

  home.packages = with pkgs; [
    # jq        # ?
    # rnix-lsp  # lsp support of nix
    # xclip     # using for neovim clipboard
    # zola      # blog
    firefox
    google-chrome

    # personal packages
    ls-colors

    # Clash
    clash
    clash-verge
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
