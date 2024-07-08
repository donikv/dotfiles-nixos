{ config, lib, pkgs, ... }:

{
  # imports = [ 
  #   ../cava
  # ];
  
  gtk = {
    enable = true;
    iconTheme = {
      name = "Arc";
      package = pkgs.arc-icon-theme;
    };

    theme = {
      name = "Arc-Dark";
      package = pkgs.arc-theme;
    };

    cursorTheme = {
      name = "Bibata-Modern-Classic";
      package = pkgs.bibata-cursors;
    };
  };

  qt = {
    enable = true;
    platformTheme.name = "adwaita";
    style.name = "kvantum";
  };
  
  xdg.configFile = {
    "Kvantum/ArcDark".source = "${pkgs.arc-kde-theme}/share/Kvantum/ArcDark";
    "Kvantum/kvantum.kvconfig".text = "[General]\ntheme=ArcDark";
  };
}
