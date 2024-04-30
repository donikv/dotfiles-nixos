{pkgs ? import <nixpkgs> { }, plasma-manager, ...}: {

  # qt = {
  #   enable = true;
  #   platformTheme = "qtct";
  #   style.name = "kvantum";
  # };
  
  # xdg.configFile = {
  #   "Kvantum/ArcDark".source = "${pkgs.arc-kde-theme}/share/Kvantum/ArcDark";
  #   "Kvantum/kvantum.kvconfig".text = "[General]\ntheme=ArcDark";
  # };
  # imports = [
  #   plasma-manager.homeManagerModules.plasma-manager
  # ];

  programs.plasma = {
    enable = true;
    workspace = {
      clickItemTo = "select";
      lookAndFeel = "org.kde.breezetwilight.desktop";
      cursorTheme = "Bibata-Modern-Ice";
      iconTheme = "Papirus";
      wallpaper = "${pkgs.libsForQt5.plasma-workspace-wallpapers}/share/wallpapers/Patak/contents/images/1080x1920.png";
    };
    panels = [
      # Windows-like panel at the bottom
      {
        location = "bottom";
        height = 60;
        widgets = [
          {
            name = "org.kde.plasma.kickoff";
            config = {
              General.icon = "nix-snowflake-white";
            };
          }
          # We can also configure the widgets. For example if you want to pin
          # konsole and dolphin to the task-launcher the following widget will
          # have that.
          {
            name = "org.kde.plasma.icontasks";
            config = {
              General.launchers = [
                "applications:org.kde.dolphin.desktop"
                "applications:org.kde.konsole.desktop"
                "applications:firefox.desktop"
                "applications:code.desktop"
                "applications:spotify.desktop"
              ];
            };
          }
          "org.kde.plasma.marginsseparator"
          "org.kde.plasma.systemtray"
          "org.kde.plasma.digitalclock"
        ];
      }
      # Global menu at the top
      {
        location = "top";
        height = 26;
        widgets = [
          "org.kde.plasma.appmenu"
        ];
      }
    ];
    configFile = {
      baloofilerc."Basic Settings"."Indexing-Enabled" = false;
      kwinrc."org.kde.kdecoration2".ButtonsOnLeft = "SF";
      kwinrc.Desktops.Number = {
        value = 8;
        # Forces kde to not change this value (even through the settings app).
        immutable = true;
      };
      kscreenlockerrc = {
        Greeter.WallpaperPlugin = "org.kde.potd";
        # To use nested groups use / as a separator. In the below example,
        # Provider will be added to [Greeter][Wallpaper][org.kde.potd][General].
        "Greeter/Wallpaper/org.kde.potd/General".Provider = "bing";
      };
    };
  };
}
