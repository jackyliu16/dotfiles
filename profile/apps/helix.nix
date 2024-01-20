{ pkgs, ... }: {
  programs.helix = {
    enable = true;
    package = pkgs.helix;

    settings = {
      # theme = "";
      editor = {
        line-number = "relative";
        cursorline = true;
        color-modes = true;
        lsp.display-messages = true;
        cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
        };
        indent-guides.render = true;
      };
      key.normal = {
        space = {
          space = "file_picker";
          w = ":w";
          q = ":q";
        };
        esc = [ "collapse_selection" "keep_primary_selection" ];
      };
    };
    
    # extraPackages = [];
    languages = with pkgs; {
      language-server.rust-analyzer.config.check.command = "clippy";
      language-server.nil.command = lib.getExe nil;
      # language-server.pyright-langserver args = ["--stdio"] };

      language = [
        {
          name = "nix";
          auto-format = true;
          formatter = {
            command = lib.getExe alejandra;
            args = ["-q"];
          };
        }
        {
          name = "rust";
          auto-format = true;
          formatter = {
            command = lib.getExe rustfmt;
          };
        }

        # {
        #   name = "rust";
        #   auto-format = false;
        # } {
        #   name = "markdown";
        #   formatter = {
        #     command = "prettier";
        #     args = ["--parser" "markdown"];
        #   };
        #   auto-format = true;
        # } {
        #   name = "nix";
        #   formatter.command = "alejandra";
        #   auto-format = true;
        # } {
        #   name = "go";
        #   auto-format = true;
        # } {
        #   name = "python";
        #   scope = "source.python";
        #   # injection-regax = "python";
        #   # file-types = [ "py" "pyi" "py3" "pyw" "ptl" ".pythonstartup" ".pythonrc" "SConstruct" ];
        #   # shebangs = [ "python" ];
        #   # roots = [ "setup.py" "setup.cfg" "pyproject.toml" ];
        #   # comment-token = "#";
        #   # language-server = { command = "pyright-langserver", args = ["--stdio"] };
        #   # indent = { tab-width = 4, unit = "    " };
        #   # config = {};
        # } {
        #   name =  "c";
        # }
      ];
    };

    # themes = {};
  };
}
