{ pkgs ? import <nixpkgs> {}, ...} :{
  services.flatpak.packages = [
    io.missioncenter.MissionCenter
  ];

  services.flatpak.update.auto = {
    enable = true;
    onCalendar = "weekly"; # Default value
  };
}