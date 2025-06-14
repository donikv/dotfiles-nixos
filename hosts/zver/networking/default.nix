{ config, lib, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    nftables
    iptables
  ];
  
  networking.firewall = { 
    enable = true;
    allowPing = true;
    logRefusedConnections = false;
  }; 
  
  networking.firewall.extraCommands = ''
    iptables -F INPUT

    # Drop by default
    iptables -P INPUT DROP
    iptables -P FORWARD DROP
    iptables -P OUTPUT ACCEPT

    # Allow loopback
    iptables -I INPUT 1 -i lo -j ACCEPT

    # Allow established connections
    iptables -I INPUT 2 -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT

    # Allow traffic from specified IPs and subnet
    iptables -I INPUT 3 -s 10.0.0.0/8 -j ACCEPT
    iptables -I INPUT 4 -s 161.53.78.45 -j ACCEPT
    iptables -I INPUT 5 -s 161.53.78.46 -j ACCEPT
    iptables -I INPUT 6 -j DROP
  '';

  networking.firewall.extraStopCommands = ''
    iptables -F INPUT
    iptables -P INPUT ACCEPT
  '';
}