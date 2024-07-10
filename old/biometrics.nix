{pkgs ? import <nixpkgs> {}, ...} :{
  environment.systemPackages = [
    pkgs.fprintd
  ];
  services.fprintd = {
    enable = true;
    package = pkgs.fprintd-tod;
    tod = {
      enable = true;
      driver = pkgs.libfprint-2-tod1-vfs0090;
    };
  };
  
  #services.fprintd.enable = true;
  #services.fprintd.tod.enable = true;
  #services.fprintd.tod.driver = pkgs.libfprint-2-tod1-goodix; #(If the vfs0090 Driver does not work, use the following driver)
}
