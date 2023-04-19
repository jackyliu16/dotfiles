{ pkgs 
, clash 
, ... }: {

  ###################
  # PUBLIC SERVICES #
  ###################

  # This setups a SSH server. Very important if you're setting up a headless system.
  # Feel free to remove if you don't need it.
  services = {
    flatpak.enable = true;
    openssh = {
      enable = true;
      # Forbid root login through SSH.
      permitRootLogin = "no";
      # Use keys only. Remove if you want to SSH using password (not recommended)
      passwordAuthentication = false;

      # settings = {
      #   # Forbid root login through SSH.
      #   PermitRootLogin = "no";
      #   # Use keys only. Remove if you want to SSH using password (not recommended)
      #   PasswordAuthentication = false;
      # };
    };
    xserver = { 
      enable = true;
      displayManager.sddm.enable = true;
      desktopManager.plasma5.enable = true;
      layout = "us";
      xkbVariant = "";
    };
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # If you want to use JACK applications, uncomment this
      # jack.enable = true;

      # use the example session manager (no others are packaged yet so this is enabled by default,
      # no need to redefine it in your config for now)
      # media-session.enable = true;
    };  
    # Enable CUPS to print documents
    printing.enable = true;
    # sound.enable = true;
    # TODO unfinish
  };

  ###################
  # CUSTOM SERVICES #
  ###################

  imports = [
    ./clash.nix # custom clash configuration
  ];

  services = {
    clash = {
      enable = true;
    };
  };
}
