{pkgs ? import <nixpkgs> { }, ...}: {

  
  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
 # gsettings set org.gnome.desktop.wm.preferences button-layout "close,minimize,maximize:"
  home-manager.users.donik = {
    dconf.settings = {
        "org/gnome/desktop/wm/preferences" = {
            button-layout = "close,minimize,maximize:";
        };
        "org/gnome/desktop/interface" = {
            color-scheme = "prefer-light";
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
            ];

        };

#	"org/gnome/shell/extensions/dash-to-dock" = {
#	  background-opacity=0.8;
#	  dash-max-icon-size=32;
#	  dock-position="BOTTOM";
#	  height-fraction=0.9;
#	  multi-monitor=false;
#	  preferred-monitor=-2;
#	  preferred-monitor-by-connector="eDP-1";
#	};
    };
  };
  environment.systemPackages = with pkgs.gnomeExtensions; [ 
    appindicator
    dash-to-dock
  ];
  services.udev.packages = with pkgs; [ gnome.gnome-settings-daemon ];
}

