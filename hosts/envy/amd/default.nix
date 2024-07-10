{pkgs ? import <nixpkgs> {}, ...} :{
 # boot.initrd.kernelModules = [ "amdgpu" ];
 # 
 # services.xserver.enable = true;
 # services.xserver.videoDrivers = [ "amdgpu" ];
 # 
  hardware.opengl.enable = true;
  hardware.opengl.driSupport32Bit = true;
  hardware.opengl.extraPackages = with pkgs; [
    rocmPackages.clr
    vaapiVdpau
    libvdpau-va-gl
    libva-utils
    amdvlk
  ];
  hardware.opengl.extraPackages32 = with pkgs.pkgsi686Linux; [ vaapiVdpau libvdpau-va-gl libva-utils amdvlk ];
}
