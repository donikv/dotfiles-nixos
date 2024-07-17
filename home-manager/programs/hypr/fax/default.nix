{ config, lib, pkgs, hn, ... }:
{
  imports = [ 
    ./hyprland-environment.nix
    ./hypridle.nix
  ];
}