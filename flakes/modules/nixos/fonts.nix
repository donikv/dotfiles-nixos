{pkgs, ... }: {
 
  fonts.packages = with pkgs; [
    ubuntu_font_family
    liberation_ttf
    # Persian Font
    vazir-fonts
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    nerdfonts
    meslo-lgs-nf
    (nerdfonts.override { fonts = [ "InconsolataLGC" "Noto" ]; })
  ];

  fonts = {
    enableDefaultPackages = true;
    fontconfig = {
      defaultFonts = {
        serif = [  "Noto" "Vazirmatn" ];
        sansSerif = [ "Noto" "Vazirmatn" ];
        monospace = [ "Noto" ];
      };
    };
  };
}