{ config, lib, pkgs, ... }:
{
  imports = [
    ./fonts
    ./virtualisation
    ./syncthing
    #./plasma
    ./gnome
    ./hypr
    ./nvidia
    ./locale
    ./gaming
    ./flatpak
  ];

#   programs.regreet.enable = true;
#   services.greetd = {
#     enable = true;
#     settings = {
#       initial_session = {
#         user = "donik";
#         command = "$SHELL -l";
#       };
#     };
#   };

programs = {
    bash = {
      interactiveShellInit = ''
        if [ -z $DISPLAY ] && [ "$(tty)" = "/dev/tty1" ]; then
           WLR_NO_HARDWARE_CURSORS=1 Hyprland #prevents cursor disappear when using Nvidia drivers
        fi
      '';
    };
  };

  programs.dconf.enable = true;

  services.teamviewer.enable = true;
  services.tailscale.enable = true;

  xdg.portal = {
    enable = true;
    wlr.enable = true;
  };

  #NETWORKING FOR KDE CONNECT
  networking.firewall = { 
    enable = true;
    allowedTCPPortRanges = [ 
      { from = 1714; to = 1764; } # KDE Connect
    ];  
    allowedUDPPortRanges = [ 
      { from = 1714; to = 1764; } # KDE Connect
    ];  
  };  
}
