{ config, lib, pkgs, ... }:
{
  imports = [
    ../zver
  ];
  
  systemd.services.NetworkManager-wait-online.enable = false;
  users.ldap.extraConfig = ''
      pam_filter memberOf=cn=zver11,ou=Machines,dc=ipg,dc=com
  '';
  networking = {
    interfaces.enp4s0 = {
      ipv4.addresses = [{
        address = "161.53.64.228";
        prefixLength = 24;
      }
      {
        address = "10.53.64.228";
        prefixLength = 16;
      }
      ];
    };
    defaultGateway = {
      address = "10.53.0.1";
      interface = "enp4s0";
    };
  };
 networking.nameservers = [ "8.8.8.8" "8.8.4.4" ];
 networking.hosts = {
    "127.0.1.1" = ["zver11"];
    "127.0.0.1" = ["localhost"];
 #   "192.0.2.1" = ["mail.example.com" "imap.example.com"];
 };
 # Aditional networking options
 # Host port open from anywhere (outside Docker)
 networking.firewall.allowedTCPPorts = [ 5555 ];
  
 networking.firewall.extraCommands = lib.mkAfter ''
  # Published container ports reachable from anywhere
  # EICACS WEBAPP
  iptables -I DOCKER-USER 1 -p tcp --dport 8081 -j ACCEPT
  # iptables -I DOCKER-USER 1 -p tcp --dport 27017 -j ACCEPT
  # DENIS ZUBARI
  iptables -I DOCKER-USER 1 -p tcp --dport 5672 -j ACCEPT
  iptables -I DOCKER-USER 1 -p tcp --dport 15672 -j ACCEPT
 '';
}
