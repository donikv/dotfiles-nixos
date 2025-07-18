{ config, lib, pkgs, ... }:
{
  imports = [
    ../zver
  ];
  
  systemd.services.NetworkManager-wait-online.enable = false;
  users.ldap.extraConfig = ''
      pam_filter memberOf=cn=zver1,ou=Machines,dc=ipg,dc=com
  '';
  networking = {
    interfaces.enp0s25 = {
      ipv4.addresses = [{
        address = "161.53.64.237";
        prefixLength = 24;
      }
      {
        address = "10.53.64.237";
        prefixLength = 16;
      }
      ];
    };
    defaultGateway = {
      address = "10.53.0.1";
      interface = "enp0s25";
    };
  };
 networking.nameservers = [ "8.8.8.8" "8.8.4.4" ];
 networking.hosts = {
    "127.0.1.1" = ["zver1"];
    "127.0.0.1" = ["localhost"];
 #   "192.0.2.1" = ["mail.example.com" "imap.example.com"];
 };
}
