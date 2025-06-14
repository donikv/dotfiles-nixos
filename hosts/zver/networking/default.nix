{ config, lib, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    nftables
    iptables
  ];
  
  networking.firewall = { 
    enable = false;
  }; 
  #networking.firewall.enable = true;
  # networking.firewall.allowPing = true;  # adjust as needed
  # networking.firewall.logRefusedConnections = false;  # adjust as needed

  # networking.firewall.extraCommands = ''
  #   iptables -P INPUT DROP
  #   iptables -A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
  #   iptables -A INPUT -i lo -j ACCEPT
  #   iptables -A INPUT -s 10.0.0.0/8 -j ACCEPT
  #   iptables -A INPUT -s 161.53.78.45 -j ACCEPT
  #   iptables -A INPUT -s 161.53.78.46 -j ACCEPT
  # '';

  # networking.firewall.extraStopCommands = ''
  #   iptables -F
  #   iptables -P INPUT ACCEPT
  # '';

  boot.extraCommands = ''
    iptables -F
    iptables -P INPUT DROP
    iptables -P FORWARD DROP
    iptables -P OUTPUT ACCEPT

    iptables -A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
    iptables -A INPUT -i lo -j ACCEPT
    iptables -A INPUT -s 10.0.0.0/8 -j ACCEPT
    iptables -A INPUT -s 161.53.78.45 -j ACCEPT
    iptables -A INPUT -s 161.53.78.46 -j ACCEPT
  '';

  boot.postBootCommands = ''
    echo "Custom iptables rules applied"
  '';
}