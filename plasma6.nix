{pkgs ? import <nixpkgs> { }, ...}: {
  
  imports = [
    <kde2nix/nixos.nix>
  ];
  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma6.enable = true;
  services.xserver.displayManager.defaultSession = "plasmawayland";
}
