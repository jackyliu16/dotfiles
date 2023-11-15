{ pkgs, ... }: {
  imports = [
    ./apps/vim.nix
  ];

  home.packages = with pkgs; [
    # Command Line Tools 
    tldr        # Command Helper 
    fzf         # File Name Searcher
    ripgrep     # File Content Searcher         ~ grep
    tmux        # Multiterminal Window Manager  
    zellij      # Multiterminal Window Manager  
    htop        # Resource Monitor              ~ top
    ranger      # File Explorer

    # Coding
    gnumake
  ];
}