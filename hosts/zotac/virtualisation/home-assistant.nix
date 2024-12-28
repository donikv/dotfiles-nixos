{pkgs, ...} : {  
  #virtualisation.docker.enable = true;
  #users.users.donik.extraGroups = ["docker"];
  networking.firewall.allowedTCPPorts = [ 8123 ];
  virtualisation.oci-containers = {
    backend = "docker";
    containers.homeassistant = {
      volumes = [ "home-assistant:/config" ];
      environment.TZ = "Europe/Berlin";
      image = "ghcr.io/home-assistant/home-assistant:stable"; # Warning: if the tag does not change, the image will not be updated
      extraOptions = [ 
        "--privileged"
        "--network=host" 
        #"--device=/dev/ttyUSB0:/dev/ttyUSB0"  # Example, change this to match your own hardware
      ];
    };
  };

  systemd.services.restart_homeassistant = {
    serviceConfig.Type = "oneshot";
    script = ''
      echo "Restarting homeassistant"
      ${pkgs.zsh}/bin/zsh /home/donik/homeassistant/restart_homeassistant.sh
      echo "Done."
      '';
    };

    systemd.timers.restart_homeassistant = {
      wantedBy = [ "timers.target" ];
      partOf = [ "restart_homeassistant.service" ];
      timerConfig.OnCalendar = [ "*-*-* *:00:00" ];
    };
}
