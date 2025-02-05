{ pkgs, lib, ... }: {
  virtualisation = {
    docker = {
      enable = true;
    };
    virtualbox.guest = { enable = true; };
    virtualbox.host = { enable = true; };
    # KVM FrameRelay for Looking Glass
    kvmfr = {
      enable = true;
      shm = {
        enable = true;
        size = 128;
        user = "bree";
        group = "qemu-libvirtd";
        mode = "0666";
      };
    };
    # USB redirection in virtual machine
    # spiceUSBRedirection.enable = true;
    waydroid.enable = true;    
  };

  # for waydroid
  environment.systemPackages = with pkgs; [
    nur.repos.ataraxiasjel.waydroid-script
  ];
}
