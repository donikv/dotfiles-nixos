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
    ncdu
    python313Packages.pip
    screen
    tmux
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
 

  services.openssh = {
     enable = true;
     ports = [ 443 5555 ];
     settings.PermitRootLogin = "yes";
     settings.UseDns = false;
  };
  services.sshd.enable = true;

  # NFSv4 client tooling. Harmless if already enabled elsewhere in your config.
  # (rpcbind is NOT required for pure NFSv4; only add it if you fall back to v3.)
  services.rpcbind.enable = lib.mkDefault true;

  fileSystems."/mnt/nas" = {
    device  = "10.53.6.1:/mnt/Storage/NetworkShare/zveri";
    fsType  = "nfs";
    options = [
      "nfsvers=4.2"          # single TCP/2049, no statd/lockd port dance
      "rsize=1048576"
      "wsize=1048576"
      "hard"                 # backup target: block rather than silently drop writes
      "noatime"
      "_netdev"              # this is a network fs; order after network is up
      "nofail"               # boot proceeds even if the NAS is down
      "x-systemd.automount"  # mount lazily on first access, not at boot
      "x-systemd.idle-timeout=600"    # unmount after 10 min idle
      "x-systemd.mount-timeout=15s"   # give up a stalled mount attempt quickly
    ];
  };

  # Ensure the mountpoint exists (systemd creates it for automounts, but this is
  # explicit and avoids surprises if you ever drop the automount option).
  systemd.tmpfiles.rules = [
    "d /mnt/nas 0755 root root - -"
  ];

  system.stateVersion = "24.11"; # Did you read the comment?
}
