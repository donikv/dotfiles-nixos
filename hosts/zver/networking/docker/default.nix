{ config, lib, pkgs, ... }: {

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
};
