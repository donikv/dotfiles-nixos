{ pkgs, ... }:

{
  # imports = [
  #   ../cava
  # ];

  catppuccin = {
    enable = true;
    flavor = "macchiato";
    accent = "teal";
    # pointerCursor = {
    #   enable = true;
    #   accent = "teal";
    # };
  };

  # Enable Theme
  # environment.variables.GTK_THEME = "catppuccin-macchiato-teal-standard+default";
  # environment.variables.XCURSOR_THEME = "Catppuccin-Macchiato-Teal";
  # environment.variables.XCURSOR_SIZE = "24";
  # environment.variables.HYPRCURSOR_THEME = "Catppuccin-Macchiato-Teal";
  # environment.variables.HYPRCURSOR_SIZE = "24";
  #qt.enable = true;
  #qt.platformTheme = "gtk";
  #qt.style = "gtk2";
  # console = {
  #   earlySetup = true;
  #   colors = [
  #     "24273a"
  #     "ed8796"
  #     "a6da95"
  #     "eed49f"
  #     "8aadf4"
  #     "f5bde6"
  #     "8bd5ca"
  #     "cad3f5"
  #     "5b6078"
  #     "ed8796"
  #     "a6da95"
  #     "eed49f"
  #     "8aadf4"
  #     "f5bde6"
  #     "8bd5ca"
  #     "a5adcb"
  #   ];
  # };

  # Override packages
  nixpkgs.config.packageOverrides = pkgs: {
    colloid-icon-theme = pkgs.colloid-icon-theme.override { colorVariants = ["teal"]; };
    catppuccin-gtk = pkgs.catppuccin-gtk.override {
      accents = [ "teal" ]; # You can specify multiple accents here to output multiple themes 
      size = "standard";
      variant = "macchiato";
    };
    discord = pkgs.discord.override {
      withOpenASAR = true;
      withTTS = true;
    };
  };

  home.packages = with pkgs; [
    numix-icon-theme-circle
    colloid-icon-theme
    catppuccin-gtk
    catppuccin-kvantum
    catppuccin-cursors.macchiatoTeal

    # gnome.gnome-tweaks
    # gnome.gnome-shell
    # gnome.gnome-shell-extensions
    # xsettingsd
    # themechanger
  ];
  gtk = {
    enable = true;
    iconTheme = {
      name = "Colloid-teal";
      package = pkgs.colloid-icon-theme;
    };

    theme = {
      name = "catppuccin-macchiato-teal-standard+default";
      package = pkgs.catppuccin-gtk;
    };

    cursorTheme = {
      name = "Bibata-Modern-Classic";
      package = pkgs.bibata-cursors;
    };
  };
  # qt = {
  #   enable = true;
  #   platformTheme.name = "adwaita";
  #   style.name = "kvantum";
  # };
  
  # xdg.configFile = {
  #   "Kvantum/ArcDark".source = "${pkgs.arc-kde-theme}/share/Kvantum/ArcDark";
  #   "Kvantum/kvantum.kvconfig".text = "[General]\ntheme=ArcDark";
  # };
}