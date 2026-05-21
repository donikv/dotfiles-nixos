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
  systemd.services.docker = {
    # Ordering: don't start Docker until the firewall and network are up.
    # The firewall sets -P FORWARD DROP and Docker installs its FORWARD/DOCKER
    # rules on top of that — so Docker must come *after* the firewall, otherwise
    # its rules get clobbered when the firewall configures itself.
    after = [ "firewall.service" "network-online.target" ];
  
    # network-online.target is only reached if something pulls it in.
    # 'after' alone just orders; 'wants' actually requests it, so Docker
    # waits for interfaces to be configured before starting.
    wants = [ "network-online.target" ];
  
    # The fix for the recurring desync: whenever firewall.service restarts
    # (e.g. a nixos-rebuild that changes the firewall), systemd restarts
    # Docker too. This forces Docker to re-plumb its iptables rules —
    # FORWARD, DOCKER, DOCKER-USER, per-bridge ACCEPTs — against the freshly
    # rebuilt firewall, instead of being left in a half-broken state.
    partOf = [ "firewall.service" ];
  
    # Anti-flapping window. systemd marks a service 'start-limit-hit' and
    # gives up if it starts more than <burst> times within <interval>.
    # Defaults (5 starts / 10s) are tight — a series of reloads or a slow
    # restart can trip them and lock Docker out. Widen to 10 starts / 60s.
    startLimitIntervalSec = 60;
    startLimitBurst = 10;
  
    serviceConfig = {
      # Give Docker up to 60s to stop cleanly. If it has many containers and
      # systemd SIGKILLs it early (default can be too short), it leaves stale
      # state that makes the *next* start fail — which is how a flap begins.
      TimeoutStopSec = 60;
  
      # Wait 5s between restart attempts instead of hammering immediately.
      # Spacing attempts out keeps them from all landing inside the
      # start-limit window and tripping the anti-flapping protection.
      RestartSec = 5;
    };
  };
}
