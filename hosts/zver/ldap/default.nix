{ lib, config, pkgs, ... }:
{
  
  environment.systemPackages = with pkgs; [
    openldap
    openssl
    cacert
  ];

  users.ldap = {
    enable = true;
    #daemon.enable = true;
    base = "dc=ipg,dc=com";
    server = "ldap://zver0.zesoi.fer.hr";
    useTLS = true;
    extraConfig = ''
      ldap_version 3
      pam_password md5
      binddn cn=administrator,dc=ipg,dc=com
      bindpw Couchman1307
      #pam_filter memberOf=cn=zver13,ou=Machines,dc=ipg,dc=com EDITED IN INDIVIDUAL CONFIG
      TLS_REQCERT allow
      #TLS_CACERT /etc/ldap_ssl/ca.crt
      SASL_MECH SIMPLE
    '';
    bind = {
     policy = "hard_open";
     timeLimit = 5;
   };
  };

  security.pam.services.sshd = {
    makeHomeDir = true;
  };

  
  security.sudo.extraRules = [
    { groups = [ "sudoGroup" ]; commands = [ "ALL" ]; }
  ];  

  environment.etc.allowed_groups = {
    text = "employee";
    mode = "0444";
  };
  
  # evil, horrifying hack for dysfunctional nss_override_attribute_value
  systemd.tmpfiles.rules = [
    "L /bin/bash - - - - /run/current-system/sw/bin/bash"
  ];

  systemd.services.logind-healthcheck = {
    description = "Restart systemd-logind if unresponsive";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = pkgs.writeShellScript "logind-healthcheck" ''
        ${pkgs.bustle}/bin/busctl status org.freedesktop.login1 || \
          systemctl restart systemd-logind
      '';
    };
  };
  
  systemd.timers.logind-healthcheck = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "*-*-* 03:00:00";
      Persistent = true;
    };
  };
}
