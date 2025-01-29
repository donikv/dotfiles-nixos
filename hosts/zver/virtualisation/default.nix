{ config, pkgs, user, lib, ... }:

{
  imports = [
    ./prometheus
  ];
  virtualisation = {
    docker.enable = true;
    docker.enableNvidia = true;
  };
  
  users.groups.docker = lib.mkForce {
    gid = 131;
  };
  
  users.groups.nscd = lib.mkForce {
    gid = 998;
  }; 
 
  #hardware.nvidia-container-toolkit.enable = true;
  
  #users.groups.docker.members = [ "ipg" ];

  environment.systemPackages = with pkgs; [
    docker-compose
  ];
}
