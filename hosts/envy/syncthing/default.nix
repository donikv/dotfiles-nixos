{ config, pkgs, ... }: {
  services = {
    syncthing = {
      enable = true;
      user = "donik";
      dataDir = "/home/donik/Documents";
      configDir = "/home/donik/Documents/.config/syncthing";
      overrideDevices = true;     # overrides any devices added or deleted through the WebUI
      overrideFolders = true;     # overrides any folders added or deleted through the WebUI
      settings = {
        devices = {
          "S24Ultra" = { id = "ZXEBA6R-M7VP3WG-7PMK2E5-KPAHRTE-566OJWV-2W7LFNV-2ZM2LFM-OMP4EQX"; };
          "Lithium" = {id = "I234VTO-FX44ODQ-GUTWWMR-QEVMSJI-VMHJOOP-7YQLMJ5-Z7K7ZQG-N6ADZAR"; }; 
        };
        folders = {
          "Obsidian" = {         # Name of folder in Syncthing, also the folder ID
            path = "/home/donik/Documents/Obsidian";    # Which folder to add to Syncthing
            devices = [ "S24Ultra" "Lithium" ] ;      # Which devices to share the folder with
          };
        };
      };
    };
  };

  services.syncthing.settings.gui = {
    user = "donik";
    password = "syncthing";
  };

  networking.firewall.allowedTCPPorts = [ 8384 22000 ];
  networking.firewall.allowedUDPPorts = [ 22000 21027 ];

}