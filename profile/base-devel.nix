flakeArgs@{ pkgs, inputs, outputs, ... }:
{ enableNixDev, ... }: {
  imports = [
    # ./apps/vim.nix
    # (import ./apps/vscodium.nix { inherit inputs pkgs ; })
    ./services/redshift.nix                           # Control Monitor Temperature

    # terminal application
    (import ./apps/neovim/default.nix flakeArgs)
    (import ./apps/neovim/packages.nix flakeArgs)
    ./apps/navi.nix                                   # Command-Line Memos
    ./apps/helix.nix
    ./apps/shells.nix
    ./apps/zellij.nix
    ./direnv.nix
  ];

  home.packages = (with pkgs; [
    # Command Line Tools 
    tldr        # Command Helper 
    tree        # File Struct
    fzf         # File Name Searcher
    ripgrep     # File Content Searcher         ~ grep

    tmux        # Multiterminal Window Manager  
    htop        # Resource Monitor              ~ top
    btop gotop nmon s-tui


    ranger      # File Explorer
    yazi        # File Explorer
    ncdu        # Disk usage analyzer           ~ spacesniffer
    duf         # Mount point usage analyzer

    cheat       # cheatSheet of CLI command

    xxd         # Read Hex Files
    lnav        # The Logfile Navigator
    cloc        # A program that counts lines of source code
    dtc         # Device Tree Compiler
    unzip       # zip
    p7zip       # 7z 

    # Proxy
    cachix

    # Network
    ethtool
    wireshark   # It looks like collision with tshark
    # tshark
    tcpdump
    nettools    # net-tools
    speedtest-cli

    # Helix Request
    # clang
    # libclang
    unstable.rust-analyzer
    nil
    gopls
    taplo
    pyright
    # pylsp

    # Coding
    gnumake
  ]) ++ (with pkgs.unstable; [
    just        # Justfile
  ]) ++ (if enableNixDev then with pkgs; [ 
    # nix-init
    nixpkgs-fmt
    nixpkgs-review
    nix-output-monitor # Processes output of Nix commands to show helpful and pretty information
    nvd                # Nix/NixOS package version diff tool
    nix-doc            # interactive Nix documentation tool 

    # (writeShellScriptBin "nrepl" ''
    #   export PATH=${pkgs.coreutils}/bin:${pkgs.nixUnstable}/bin:$PATH
    #   if [ -z "$1" ]; then
    #      nix repl --argstr host "$HOST" --argstr flakePath "$PRJ_ROOT" ${./apps/nrepl.nix}
    #    else
    #      nix repl --argstr host "$HOST" --argstr flakePath $(readlink -f $1 | sed 's|/flake.nix||') ${./apps/nrepl.nix}
    #    fi
    # '')

    #-- shash "$url" -> SRI format hash
    (writeShellScriptBin "shash" ''
      nix hash to-sri --type sha256 $(nix-prefetch-url ''$1)
    '')
  ] else [] );
}
