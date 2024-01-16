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
  (vscode-with-extensions.override {
    vscodeExtensions = with vscode-extensions; [
      bbenoist.nix
      ms-python.python
      ms-vscode-remote.remote-ssh
      vscodevim.vim
      arrterian.nix-env-selector
    ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      {
        name = "remote-ssh-edit";
        publisher = "ms-vscode-remote";
        version = "0.47.2";
        sha256 = "1hp6gjh4xp2m1xlm1jsdzxw9d8frkiidhph6nvl24d0h8z34w49g";
      }]
      ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      {
        name = "copilot";
        publisher = "GitHub";
        version = "1.46.6822";
        sha256 = "sha256-L71mC0190ZubqNVliu7es4SDsBTGVokePpcNupABI8Q=";
      }];
     })
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
