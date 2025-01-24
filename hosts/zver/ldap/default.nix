{ lib, config, pkgs, ... }:
{
  
  environment.systemPackages = with pkgs; [
    openldap
    openssl
  ];

  users.ldap = {
    enable = true;
    base = "dc=ipg,dc=com";
    server = "ldap://10.53.64.207 ldap://10.53.6.24";
    useTLS = true;
    extraConfig = ''
      ldap_version 3
      pam_password md5
      # binddn cn=administrator,dc=ipg,dc=com
      # bindpw Couchman1307
      pam_filter memberOf=cn=zver13,ou=Machines,dc=ipg,dc=com
      TLS_REQCERT allow
      TLS_CACERT /etc/ssl/certs/ca-certificates.crt
    '';
   # daemon = {
   #   enable = true;
   #   rootpwmoddn = "dn=admin,dc=ipg,dc=com";
   # };
    bind.distinguishedName = "cn=admin,dc=ipg,dc=com";
    bind.passwordFile = "/etc/bind_password";
    bind.policy = "soft";
  };
  
  environment.etc = {
    ssl.source = ./ssl;
  };
  security.pki.certificateFiles = ["/etc/ssl/ca.crt"];


  security.pam.services.sshd = {
    makeHomeDir = true;
    # see https://stackoverflow.com/a/47041843 for why this is required
   # text = lib.mkDefault (
   #   lib.mkBefore ''
   #     auth required pam_listfile.so \
   #       item=group sense=allow onerr=fail file=/etc/allowed_groups
   #   ''
   # );
  };
  security.pam.services.common-session = {
    text = lib.mkDefault (
      lib.mkAfter ''
        session required pam_mkhomedir.so skel=/etc/skel umask=077
      ''
    );
  };
  
  environment.etc.bind_password = {
    text = "zverid113";
    mode = "0444";
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
}
