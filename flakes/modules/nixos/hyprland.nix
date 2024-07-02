{pkgs ? import <nixpkgs> {},, inputs ...}: {
  programs.hyprland = {
    enable = true;
    #xwayland.enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
  };

  wayland.windowManager.hyprland.plugins = [
    inputs.hyprland-plugins.packages.${pkgs.stdenv.hostPlatform.system}.hyprbars
  ];

}