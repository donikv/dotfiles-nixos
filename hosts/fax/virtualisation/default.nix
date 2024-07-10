{ config, pkgs, user, ... }:

{
  virtualisation = {
    docker.enable = true;
    docker.enableNvidia = true;
  };

  users.groups.docker.members = [ "donik" ];

  environment.systemPackages = with pkgs; [
    docker-compose
  ];
}
