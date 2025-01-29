{pkgs ? import <nixpkgs> {}, ...} :{
  programs.adb.enable = true;
  users.users.donik.extraGroups = ["adbusers"];
  environment.systemPackages = with pkgs; [
    android-studio
  ];
}
