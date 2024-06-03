{pkgs ? import <nixpkgs> { }, ...}: {

  qt = {
    enable = true;
    platformTheme = "qtct";
    style.name = "kvantum";
  };
  
  xdg.configFile = {
    "Kvantum/ArcDark".source = "${pkgs.arc-kde-theme}/share/Kvantum/ArcDark";
    "Kvantum/kvantum.kvconfig".text = "[General]\ntheme=ArcDark";
  };
}

