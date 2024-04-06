{pkgs ? import <nixpkgs> { }, ...}: {
  # Enable the X11 windowing system.
  #services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  #services.xserver.displayManager.gdm.enable = true;
  #services.xserver.desktopManager.gnome.enable = true;

  # services.xserver.displayManager.gdm.wayland = false;
 # gsettings set org.gnome.desktop.wm.preferences button-layout "close,minimize,maximize:"


  #home.sessionVariables.GTK_THEME = "palenight";

  home-manager.users.donik = {
    dconf.settings = {
        "org/gnome/desktop/wm/preferences" = {
            button-layout = "close,minimize,maximize:";
        };
        "org/gnome/desktop/interface" = {
            color-scheme = "prefer-default";
        };
        "org/gnome/shell" = {
            favorite-apps = [
              "firefox.desktop"
              "org.gnome.Nautilus.desktop"
              "org.gnome.Terminal.desktop"
              "code.desktop"
              "spotify.desktop"
            ];
	    enabled-extensions = [
              "dash-to-dock@micxgx.gmail.com"
	            "apps-menu@gnome-shell-extensions.gcampax.github.com"
	            "appindicatorsupport@rgcjonas.gmail.com"
	            "screen-rotate@shyzus.github.io"
            ];

        };

	"org/gnome/shell/extensions/dash-to-dock" = {
	  background-opacity=0.8;
	  dash-max-icon-size=32;
	  dock-position="BOTTOM";
	  height-fraction=0.9;
	  multi-monitor=true;
	  preferred-monitor=-2;
	  preferred-monitor-by-connector="eDP-1";
	};
    };
    
    gtk = {
      enable = true;

      iconTheme = {
        name = "Papirus-Dark";
        package = pkgs.papirus-icon-theme;
      };

      theme = {
        name = "palenight";
        package = pkgs.palenight-theme;
      };

      cursorTheme = {
        name = "Numix-Cursor";
        package = pkgs.numix-cursor-theme;
      };

      gtk3.extraConfig = {
        Settings = ''
          gtk-application-prefer-dark-theme=0
        '';
      };

      gtk4.extraConfig = {
        Settings = ''
          gtk-application-prefer-dark-theme=0
        '';
      };
  };
  };
 # environment.systemPackages = with pkgs.gnomeExtensions; [ 
 #   appindicator
 #   dash-to-dock
 #   screen-rotate
 #   pkgs.gjs
 #   #pkgs.evtest
 #   #pkgs.libinput
 # ];
 # services.udev.packages = with pkgs; [ gnome.gnome-settings-daemon ];
}

