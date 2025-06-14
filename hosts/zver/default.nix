{ config, lib, pkgs, ... }:
{
  imports = [
    ./fonts
    ./virtualisation
    ./nvidia
    ./locale
    ./ldap
    ./networking
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
    vim
    git
    (python39Full.withPackages(ps: with ps; [
      ps.pip
    ]))
  ];
  
  #Link python for ansible backwards compatibility with ubuntu machines
  systemd.tmpfiles.rules = [
    "L /usr/bin/python3 - - - - /run/current-system/sw/bin/python3"
  ];

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    config.common.default = "*";
  };
  
  networking.firewall = { 
    enable = true;
  };  

  services.openssh = {
     enable = true;
     ports = [ 443 5555 ];
     settings.PermitRootLogin = "yes";
     settings.UseDns = false;
  };
  services.sshd.enable = true;
  
  system.stateVersion = "24.11"; # Did you read the comment?
}
