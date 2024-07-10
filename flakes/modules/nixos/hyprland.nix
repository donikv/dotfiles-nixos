{pkgs ? import <nixpkgs> {}, inputs, ...}: {
  programs.hyprland = {
    enable = true;
    #xwayland.enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    xwayland.enable = true;
  };

  # Hint Electon apps to use wayland
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };

  # wayland.windowManager.hyprland.plugins = [
  #   inputs.hyprland-plugins.packages.${pkgs.stdenv.hostPlatform.system}.hyprbars
  # ];

  environment.systemPackages = with pkgs; [
    hyprland
    swww # for wallpapers
    xdg-desktop-portal-gtk
    xdg-desktop-portal-hyprland
    xwayland
    meson
    wayland-protocols
    wayland-utils
    wl-clipboard
    wlroots
    kitty
    rofi-wayland
    wofi
  ];

  nixpkgs.overlays = [
    (self: super: {
      waybar = super.waybar.overrideAttrs (oldAttrs: {
        mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
      });
    })
  ];

}