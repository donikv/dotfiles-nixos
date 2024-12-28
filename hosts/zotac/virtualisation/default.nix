{ config, pkgs, user, ... }:
{
  imports = [
    ./home-assistant.nix
  ];

  virtualisation = {
    docker.enable = true;
    #docker.enableNvidia = true;
  };

  users.users.donik.extraGroups = ["docker"];
  users.groups.docker.members = [ "donik" ];

  environment.systemPackages = with pkgs; [
    docker-compose
  ];
}
