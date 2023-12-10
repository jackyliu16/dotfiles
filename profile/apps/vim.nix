{ pkgs, ... } : {
  # config: vim and neovim
  programs = {
    vim = {
      enable = true;
      plugins = with pkgs.vimPlugins; [ 
        # language support
        vim-lsp
        # asyncomplete-vim
        # jedi-vim
        vim-nix           # Nix
        rust-vim          # Rust
        coc-rust-analyzer # Rust
        coc-pyright       # Pyright
        vim-toml          # Toml
        # YouCompleteMe   # 自动补全

        # UI
        vim-gitgutter   # status in gitter
        vim-airline     # vim-devicons
        (nvim-treesitter.withPlugins (p: [ p.c p.java p.rust p.python p.go ]))
        vim-bufferline  # 标签页
        nvim-gdb
        
        ## colocscheme
        gruvbox
        vim-devicons    

        # Tools
        auto-pairs
        LeaderF         # 模糊查找
        nerdcommenter   # 多行注释支持
        Vundle-vim      # plug-in manager for Vim
        # lightline     # tabline customization
        vim-startify    # 最近打开的文件
        vim-fugitive    # Git Support

        # NERDTree
        nerdtree
        vim-nerdtree-tabs
        vim-nerdtree-syntax-highlight
        nerdtree-git-plugin
      ];
      extraConfig = builtins.readFile ./config/vimExtraConfig;
    };
  };
}
