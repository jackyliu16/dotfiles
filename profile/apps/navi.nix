{ pkgs, lib, ... }: {
  programs.navi = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
  };
}
