{ pkgs, ... }: {
  programs.helix = {
    enable = true;
    # extraPackages = [];
    languages = {
      language-server.rust-analyzer.config.check.command = "clippy";
      # language-server.pyright-langserver args = ["--stdio"] };

      language = [
        {
          name = "rust";
          auto-format = false;
        } {
          name = "markdown";
          formatter = {
            command = "prettier";
            args = ["--parser" "markdown"];
          };
          auto-format = true;
        } {
          name = "nix";
          formatter.command = "alejandra";
          auto-format = true;
        } {
          name = "go";
          auto-format = true;
        } {
          name = "python";
          scope = "source.python";
          # injection-regax = "python";
          # file-types = [ "py" "pyi" "py3" "pyw" "ptl" ".pythonstartup" ".pythonrc" "SConstruct" ];
          # shebangs = [ "python" ];
          # roots = [ "setup.py" "setup.cfg" "pyproject.toml" ];
          # comment-token = "#";
          # language-server = { command = "pyright-langserver", args = ["--stdio"] };
          # indent = { tab-width = 4, unit = "    " };
          # config = {};
        } {
          name =  "c";
        }
      ];
    };

    # themes = {};
    # settings = {};
  };
}
