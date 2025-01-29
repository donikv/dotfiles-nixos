{pkgs ? import <nixpkgs> { }, ...}: {
  environment.systemPackages = with pkgs; [
    libreoffice-qt
    hunspell
    hunspellDicts.uk_UA
    hunspellDicts.th_TH
  ];
}
