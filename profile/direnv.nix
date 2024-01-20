{ pkgs, ... }: {

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;

    enableZshIntegration = true; # see note on other shells below
    enableBashIntegration = true; # see note on other shells below
    # enableNushellIntegration = true; # see note on other shells below
  };
}
