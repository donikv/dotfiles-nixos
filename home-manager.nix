{pkgs ? import <nixpkgs> { }, ...}: 
let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-23.11.tar.gz";
in
{
    imports = [
      (import "${home-manager}/nixos")
    ];
  
    home-manager.users.donik = { 
      #home.username = "donik";
      home.homeDirectory = "/home/donik";
    /* The home.stateVersion option does not have a default and must be set */
      home.stateVersion = "23.11";
      programs.home-manager.enable = true;
      home.packages = [ pkgs.git ];
      programs.git = {
        enable = true;
        userName  = "donikv";
        userEmail = "donikv@gmail.com";
      };   
     /* Here goes the rest of your home-manager config, e.g. home.packages = [ pkgs.foo ]; */
    };
}