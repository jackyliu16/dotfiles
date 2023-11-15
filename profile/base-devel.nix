{ pkgs, enableNixDev ? false, ... }: {
  imports = [
    ./apps/vim.nix
    ./apps/zsh.nix
  ];

  home.packages = with pkgs; [
    # Command Line Tools 
    tldr        # Command Helper 
    tree        # File Struct
    fzf         # File Name Searcher
    ripgrep     # File Content Searcher         ~ grep
    tmux        # Multiterminal Window Manager  
    zellij      # Multiterminal Window Manager  
    htop        # Resource Monitor              ~ top
    ranger      # File Explorer

    # Coding
    gnumake
  ] ++ (if enableNixDev then [
    nix-init
  ] else [] );
}