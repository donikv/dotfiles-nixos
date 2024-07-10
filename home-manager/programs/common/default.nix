{pkgs, ...} : {
  home.packages = with pkgs; [
  firefox
  bitwarden
  quickemu
  spotify
  sioyek
  write_stylus
  libsForQt5.kate
  cups
  evtest
  libinput
  #discord
  maestral-gui
  maestral
  xournalpp
  libsForQt5.okular
  libsForQt5.kdeconnect-kde
  pkgs.unstable.super-productivity
  webex
  nerdfonts
  teams-for-linux
  ]; 
}
