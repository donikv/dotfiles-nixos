{pkgs, ...} : {
  services.teamviewer.enable = true;
  environment.systemPackages = with pkgs; [
  firefox
  teamviewer
  vim
  git
  bitwarden
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
  libsForQt5.kdeconnect-kde
  pkgs.unstable.super-productivity
  ];
  
  services.tailscale.enable = true;

  #NETWORKING FOR KDE CONNECT
  networking.firewall = { 
    enable = true;
    allowedTCPPortRanges = [ 
      { from = 1714; to = 1764; } # KDE Connect
    ];  
    allowedUDPPortRanges = [ 
      { from = 1714; to = 1764; } # KDE Connect
    ];  
  };  
}
