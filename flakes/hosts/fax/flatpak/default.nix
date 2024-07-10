{ pkgs ? import <nixpkgs> {}, ...} : {

  services.flatpak.enable = true;

  services.flatpak.packages = [
    #"io.missioncenter.MissionCenter"
    { appId = "com.brave.Browser"; origin = "flathub";  }
  ];

  services.flatpak.update.auto = {
    enable = true;
    onCalendar = "weekly"; # Default value
  };
}