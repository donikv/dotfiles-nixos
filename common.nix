{pkgs ? import <nixpkgs> {}, ...} : {
  services.teamviewer.enable = true;
  environment.systemPackages = with pkgs; [
  teamviewer
  vim
  git
  bitwarden
  steam
  quickemu
  spotify
  sioyek
  write_stylus
  cups
  home-manager
  evtest
  libinput
  discord
  maestral-gui
  maestral
  xournalpp
  libsForQt5.okular
  ];

  services.printing.enable = true;
  services.avahi = {
    enable = true;
    nssmdns = true;
    openFirewall = true;
  };
 
   programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  };
}
