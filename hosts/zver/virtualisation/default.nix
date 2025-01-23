{ config, pkgs, user, ... }:

{
  virtualisation = {
    docker.enable = true;
    docker.enableNvidia = true;
  };
  
  #hardware.nvidia-container-toolkit.enable = true;
  
  users.groups.docker.members = [ "ipg" ];

  environment.systemPackages = with pkgs; [
    docker-compose
  ];
}
