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
    # distinguishedName = "cn=admin,dc=ipg,dc=com";
     timeLimit = 5;
    # passwordFile = ''${pkgs.writeText "ldap-bind" "zverid113"}'';
   };
    #daemon.extraConfig = '' 
    #  binddn cn=admin,dc=ipg,dc=com
    #  bindpw zverid113
    #  filter memberOf (memberOf=cn=zver13,ou=Machines,dc=ipg,dc=com)
    #  TLS_REQCERT allow
    #  #map passwd loginShell "/run/current-system/sw/bin/bash"
    #'';
  };

  security.pam.services.sshd = {
    makeHomeDir = true;
  };
#
#  security.pam.services.common-session = {
#    text = lib.mkDefault (
#      lib.mkAfter ''
#        session required pam_mkhomedir.so skel=/etc/skel umask=077
#      ''
#    );
#  };
  
 # environment.etc.bind_password = {
 #   text = "zverid113";
 #   mode = "0444";
 # };
  
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
}
