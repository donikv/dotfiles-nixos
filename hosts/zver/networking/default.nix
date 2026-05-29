{ config, lib, pkgs, ... }:
{
  imports = [
    ./docker
  ];
  environment.systemPackages = with pkgs; [
    nftables
    iptables
  ];

  #Disable ipv6 because of the new networking configuration done at FER level to fix connectivity and ping issues.
  boot.kernel.sysctl = {
    "net.ipv6.conf.all.disable_ipv6" = 1;
    "net.ipv6.conf.default.disable_ipv6" = 1;
  };

  networking.firewall = {
    enable = true;
    allowPing = true;
    logRefusedConnections = false;
  };
  networking.firewall.extraCommands = ''
    iptables -F INPUT
    # Drop by default
    iptables -P INPUT DROP
    #iptables -P FORWARD DROP
    iptables -P OUTPUT ACCEPT
    iptables -A INPUT -p icmp --icmp-type timestamp-request -j DROP
    iptables -A OUTPUT -p icmp --icmp-type timestamp-reply -j DROP
    # Allow loopback
    iptables -I INPUT 1 -i lo -j ACCEPT
    # Allow established connections
    iptables -I INPUT 2 -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
    # Allow traffic from specified IPs and subnet
    iptables -I INPUT 3 -s 10.0.0.0/8 -j ACCEPT # Local network
    iptables -I INPUT 4 -s 161.53.0.0/16 -j ACCEPT #FER network
    iptables -I INPUT 5 -s 161.53.78.45 -j ACCEPT #FER VPN
    iptables -I INPUT 6 -s 161.53.78.46 -j ACCEPT
    iptables -I INPUT 7 -s 161.53.64.207 -j ACCEPT #ZVER 0
    iptables -I INPUT 8 -s 161.53.64.7 -j ACCEPT #ZVER Router
    iptables -I INPUT 9 -j DROP

    # === DOCKER-USER chain: apply same allowlist to containers ===
    # Create chain if it doesn't exist (Docker normally creates it, but be safe)
    iptables -N DOCKER-USER 2>/dev/null || true
    iptables -F DOCKER-USER
    # Allow return traffic for connections initiated from containers (egress)
    iptables -A DOCKER-USER -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT 
    # Allow traffic originating from the bridges (container egress + container-to-container)
    iptables -A DOCKER-USER -i docker0 -j ACCEPT
    iptables -A DOCKER-USER -i br+ -j ACCEPT
    # Allow traffic from trusted source ranges
    iptables -A DOCKER-USER -s 10.0.0.0/8 -j ACCEPT # Local network
    iptables -A DOCKER-USER -s 161.53.0.0/16 -j ACCEPT # FER network
    iptables -A DOCKER-USER -s 161.53.78.45 -j ACCEPT # FER VPN
    iptables -A DOCKER-USER -s 161.53.78.46 -j ACCEPT
    iptables -A DOCKER-USER -s 161.53.64.207 -j ACCEPT # ZVER 0
    iptables -A DOCKER-USER -s 161.53.64.7 -j ACCEPT # ZVER Router
    # Drop everything else destined for containers
    iptables -A DOCKER-USER -j DROP
  '';
  networking.firewall.extraStopCommands = ''
    iptables -F INPUT
    iptables -P INPUT ACCEPT
    # Reset DOCKER-USER to permissive on firewall stop (Docker's default)
    iptables -F DOCKER-USER 2>/dev/null || true
  '';
}
