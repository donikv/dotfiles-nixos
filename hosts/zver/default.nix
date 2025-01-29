{ config, lib, pkgs, ... }:
{
  imports = [
    ./fonts
    ./virtualisation
    ./nvidia
    ./locale
    ./ldap
 ];
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  users.users.ipg = {
    isNormalUser = true;
    description = "ipg";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    packages = with pkgs; [
    ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    neovim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget
    vim
    git
  ];
  
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    config.common.default = "*";
  };
  
  networking.firewall = { 
    enable = false;
  };  

  services.openssh = {
     enable = true;
     ports = [ 443 5555 ];
     settings.PermitRootLogin = "yes";
  };
  services.sshd.enable = true;
  
  system.stateVersion = "24.11"; # Did you read the comment?
}
