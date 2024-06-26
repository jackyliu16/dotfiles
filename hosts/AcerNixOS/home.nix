{
  inputs,
  outputs,
  config,
  pkgs ? import <nixpkgs> {},
  lib,
  ...
}: let
  # shell color: diff typr of file will have diff color
  # b = pkgs.callPackage ./src/b {};
  user = "jacky";
  domain = "ANixOS";
  enableNixDev = true;
  enableClashProxy = false; # leading to strange errors.
in {
  # Home Manager needs a bit of information about you and the
  # paths it should manage.

  imports = [
    (import ../../profile/comm.nix {inherit inputs outputs user domain enableClashProxy;})
    (import ../../profile/base-devel.nix {inherit inputs outputs pkgs enableNixDev;})
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
    config = { # Disable if you don't want unfree packages
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;
    };
  };

  home.packages =
    (with pkgs; [
      # jq        # ?
      # rnix-lsp  # lsp support of nix
      # xclip     # using for neovim clipboard

      # Web
      firefox
      google-chrome
      # qq

      # # personal packages
      # vscode

      # Monitor
      glances

      # Blog
      zola
      logseq

      qbittorrent
      wechat-uos

      translate-shell

      gparted # Linux system disk partitioning tool

      pciutils # lspci

      # Game
      # (dwarf-fortress-packages.dwarf-fortress-full.override {
      #   dfVersion = "0.47.04";
      #   theme = dwarf-fortress-packages.themes.tergel;
      #   enableIntro = true;
      #   enableFPS = true;
      # })
    ])
    ++ (with pkgs.unstable; [
    ]);

  # terminal
  programs = {
    bat = {
      enable = true;
      config = {
        # theme = "ansi-dark";
        theme = "base16-256";
      };
    };
    command-not-found.enable = false;
    bash.initExtra = ''
      source ${pkgs.nix-index}/etc/profile.d/command-not-found.sh
    '';
    bash.bashrcExtra = ''
      export XDG_DATA_HOME="$HOME/.local/share"
    '';
    nix-index.enable = true;
  };

  nixpkgs.config.permittedInsecurePackages = [
    "openssl-1.1.1w"
  ];

}
