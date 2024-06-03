{pkgs ? import <nixpkgs> { }, ...}: {
  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;
  #services.xserver.displayManager.defaultSession = "plasmawayland";

  environment.systemPackages = with pkgs; [
    bibata-cursors
    papirus-icon-theme
    numix-cursor-theme
  ];

}
