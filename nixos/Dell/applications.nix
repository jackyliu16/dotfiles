{ pkgs, lib, ... }: {
	environment.gnome.excludePackages = (with pkgs; [
	  gnome-photos
	  gnome-tour
	]) ++ (with pkgs.gnome; [
		gnome-calculator
	  cheese # webcam tool
	  gnome-music
	  # gnome-terminal
	  # gedit # text editor
	  epiphany # web browser
	  geary # email reader
	  evince # document viewer
	  gnome-characters
	  totem # video player
	  tali # poker game
	  iagno # go game
	  hitori # sudoku game
	  atomix # puzzle game
	]) ++ (with pkgs.gnomeExtensions; [
		kimpanel
	]);

  environment.systemPackages = (with pkgs.gnome; [
	  gnome-terminal
	]) ++ (with pkgs.libsForQt5; [
		neochat
	]) ++ (with pkgs; [
	  pot # A cross-platform translation software 
    listen1
    rustdesk # RDP

    qq # Messaging app

    # Secondary monitor
		# virtscreen
		x2vnc
		# miraclecast
    weylus
    deskreen
	]);
}
