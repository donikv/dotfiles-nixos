{pkgs ? import <nixpkgs> { }, ...}: {
  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.sddm.wayland.enable = true;
  services.xserver.desktopManager.plasma6.enable = true;
  #services.xserver.displayManager.defaultSession = "plasmawayland";
}
