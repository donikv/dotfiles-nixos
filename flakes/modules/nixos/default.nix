# Add your reusable NixOS modules to this directory, on their own file (https://nixos.wiki/wiki/Module).
# These should be stuff you would like to share with others, not your personal configurations.
{
  # List your module files here
  # my-module = import ./my-module.nix;
  common = import ./common.nix;
  dev = import ./dev.nix;
  gnome = import ./gnome.nix;
  plasma = import ./plasma.nix;
  i3 = import ./i3.nix;
  amd = import ./amd.nix;
  locale = import ./locale.nix;
  gaming = import ./gaming.nix;
  office = import ./office.nix;
  android = import ./android.nix;
  nvidia = import ./nvidia.nix;
  fonts = import ./fonts.nix;
}