{
gtk = true;

getWindowServer = isgtk : if isgtk then [./gnome.nix] else [./plasma.nix]; 

getPackages = {isgtk, pkgs ? import<nixpkgs> { } } : 
    if isgtk 
    then [
        pkgs.transmission-gtk
	pkgs.gnome.gnome-terminal
	pkgs.gnome.evince
    ] 
    else [
        pkgs.transmission-qt
    ];
}
