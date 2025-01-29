{pkgs ? import <nixpkgs> { }, ...}: {
  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  programs.dconf.enable = true;
  environment.systemPackages = with pkgs.gnomeExtensions; [ 
    appindicator
    dash-to-dock
    screen-rotate
    pkgs.gjs
    pkgs.transmission-gtk
    pkgs.gnome.gnome-terminal
    pkgs.gnome.evince
    pkgs.gnome.gnome-tweaks
    #pkgs.evtest
    #pkgs.libinput
  ];
  services.udev.packages = with pkgs; [ gnome.gnome-settings-daemon ];
}

