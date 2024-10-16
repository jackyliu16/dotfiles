# THis file contains personal configuration of whole system
flakeArgs@{
  pkgs,
  inputs,
  outputs,
  ...
}: let
  user = "jacky";
  domain = "ANixOS";
  enableNixDev = true;
  enableClashProxy = false; # leading to strange errors.
in {

  imports = [
    (import ../../profile/comm.nix (flakeArgs // {inherit user domain enableClashProxy;}))
    (import ../../profile/base-devel.nix (flakeArgs // {inherit enableNixDev;}))

    # outputs.homeManagerModules.jetbrains
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
      permittedInsecurePackages = [
        "openssl-1.1.1w"
      ];
    };
  };
  home.packages =
    (with pkgs; [
      # jq        # ?

      # Command Line Tools

      #-- Tester
      # dmidecode         # Mem test
      stress
      memtester
      # memtest86plus   # seems to be determined by specific systemd-boot options, not here

      translate-shell
      pciutils          # lspci, gpu

      #-- Web
      firefox
      google-chrome

      # (TEST) Note
      # ollama            # Local ChatGPT
      # oterm
      # trilium-desktop
      # notesnook

      # Game
      # mkxp-z
      # (dwarf-fortress-packages.dwarf-fortress-full.override {
      #   dfVersion = "0.47.04";
      #   theme = dwarf-fortress-packages.themes.tergel;
      #   enableIntro = true;
      #   enableFPS = true;
      # })
    ])
    ++ (with pkgs.unstable; [
      # Command Line Tools
      quickemu          # Easy qemu to run win, macOS, linux other disros
      so                # FIXME seems there is some bugs case incapable to use search 
      # zola          # Blog generate


      # Graphics
      # logseq            # FIXME Note taking 
      # qbittorrent       # BT download application
      wechat-uos        # Wechat in UOS (functional limitations)
      vlc               # Video Player
      gparted           # Linux system disk partitioning tool
      libreoffice       # Opensource Office
      # github-desktop    # Github Desktop
      gh                # Github Command Line Tools
      # rustdesk          # Remote Control
      flameshot         # PrtSc
      veracrypt         # Disk sector encryption

      #-- Monitor
      glances
      mission-center    # Monitor of CPU, Memory, Disk, Network and GPU usage

      #-- Editor
      code-cursor     # Editor base on VSC
      vscode
      lapce

      #-- Sync
      megasync
      synology-drive-client
    ]) ++ (with inputs.nix-gaming.packages.${pkgs.system}; [
      wine-ge
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
    zsh.initExtra = ''
      source ${pkgs.nix-index}/etc/profile.d/command-not-found.sh
    '';
    bash.bashrcExtra = ''
      export XDG_DATA_HOME="$HOME/.local/share"
    '';
    nix-index.enable = true;
  };

  # programs.jetbrains = {
  #   enable = true;
  #   packages = with pkgs.nixpkgs-idea-20240101.jetbrains; [ # Only support this version
  #     idea-ultimate
  #   ];
  # };
}
