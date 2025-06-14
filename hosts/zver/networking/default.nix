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
    iptables -A INPUT -i lo -j ACCEPT

    # Allow established connections
    iptables -A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT

    # Allow traffic from specified IPs and subnet
    iptables -A INPUT -s 10.0.0.0/8 -j ACCEPT
    iptables -A INPUT -s 161.53.78.45 -j ACCEPT
    iptables -A INPUT -s 161.53.78.46 -j ACCEPT
  '';

  networking.firewall.extraStopCommands = ''
    iptables -F INPUT
    iptables -P INPUT ACCEPT
  '';
}