{pkgs, ...}: {

  imports = [
    ./rider.nix
  ];

  environment.systemPackages = [
    pkgs.unityhub
  ];
}