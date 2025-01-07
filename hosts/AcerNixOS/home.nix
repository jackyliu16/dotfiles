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
in {

  imports = [
    (import ../../profile/comm.nix flakeArgs { inherit user domain; })
    (import ../../profile/base-devel.nix flakeArgs { inherit enableNixDev; })

    outputs.homeManagerModules.jetbrains
  ];

  # TODO not sure if working
  nixpkgs = {
    # You can add overlays here
    overlays = [
      inputs.nur.overlay

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
      nur.repos.novel2430.wemeet-bin-bwrap

      ovital
      # jq        # ?

      # Command Line Tools

      #-- Tester
      # dmidecode         # Mem test
      stress            # stress resource
      memtester         # alloc mem space
      # memtest86plus   # seems to be determined by specific systemd-boot options, not here

      translate-shell
      pciutils          # lspci, gpu

      #-- Web
      firefox
      google-chrome

      # Personal 
      qtscrcpy

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
      cargo-generate    # Create Apps with template
      # zola          # Blog generate

      docker-client
      docker-compose

      # Graphics
      # logseq            # FIXME Note taking 
      # qbittorrent       # BT download application
      scrcpy            # Projection mobile phone
      wpsoffice
      wechat-uos        # Wechat in UOS (functional limitations)
      vlc               # Video Player
      gparted           # Linux system disk partitioning tool
      # github-desktop    # Github Desktop
      gh                # Github Command Line Tools
      rustdesk          # Remote Control
      flameshot         # PrtSc
      veracrypt         # Disk sector encryption
      qmapshack         # Consumer grade GIS software
      listen1           # Music Player
      eudic             # Translate

      #-- Monitor
      glances
      mission-center    # Monitor of CPU, Memory, Disk, Network and GPU usage

      #-- Editor
      code-cursor     # Editor base on VSC
      jetbrains.rust-rover
      vscode
      lapce

      #-- Sync
      megasync
      synology-drive-client
    # ]) ++ (with inputs.nix-gaming.packages.${pkgs.system}; [
    #   wine-ge
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

  programs.jetbrains = {
    enable = true;
    packages = with pkgs.nixpkgs-idea-20240101.jetbrains; [ # Only support this version
      idea-ultimate
    ];
  };

  xdg.dataFile = {
    "fcitx5/rime" = {
      # source = "${pkgs.rime-ice}/share/rime-data";
      source = "${pkgs.rime-frost}/share/rime-data";
      recursive = true;
    };
    "fcitx5/rime/default.custom.yaml" = {
      text = pkgs.lib.generators.toYAML { } {
        patch = {
          "menu/page_size" = 5;
          "engine/translators/+" = [ 
            "lua_translator@*calculator_translator" # 计算器
          ];           
          "engine/filters/+" = [
            "lua_filter@cn_en_spacer"
            "lua_filter@date_translator"
            "lua_filter@*calculator_filter" # 把计算器的答案放在最前边
          ];
        };
      };
    };
  };
}
