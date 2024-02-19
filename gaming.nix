{pkgs ? import <nixpkgs> {}, ...} : {
  services.teamviewer.enable = true;
  environment.systemPackages = with pkgs; [
    steam
  ];

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