{ pkgs, lib, ... }: {
  virtualisation = {
    docker = {
      enable = true;
    };
    virtualbox.guest = { enable = true; };
    virtualbox.host = { enable = true; };
  };
}
