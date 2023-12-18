{pkgs ? import <nixpkgs> {}, ... } : {

#my-python-packages = ps: with ps; [
#    pandas
#    numpy
#    #torch    
#    #torchvision
#    # other python packages
#  ];
#
#environment.systemPackages = with pkgs; [
#  python3
#  (python3.withPackages my-python-packages)
#];
environment.systemPackages = with pkgs; [
   (python3.withPackages(ps: with ps; [pandas numpy scikit-learn]))
  ];
}
