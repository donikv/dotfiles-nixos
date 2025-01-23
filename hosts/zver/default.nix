{ config, lib, pkgs, ... }:
{
  imports = [
    ./fonts
    ./virtualisation
    ./nvidia
    ./locale

 ];
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  users.users.ipg = {
    isNormalUser = true;
    description = "ipg";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      vim
    ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    neovim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget
  ];

  xdg.portal = {
    enable = true;
    wlr.enable = true;
  };

  #NETWORKING FOR KDE CONNECT
  networking.firewall = { 
    enable = false;
  };  

  services.openssh = {
     enable = true;
     ports = [ 443 5555 ];
  };
  
  system.stateVersion = "24.11"; # Did you read the comment?
}
