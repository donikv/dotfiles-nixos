# Add your reusable home-manager modules to this directory, on their own file (https://nixos.wiki/wiki/Module).
# These should be stuff you would like to share with others, not your personal configurations.
{
  # List your module files here
  # my-module = import ./my-module.nix;
  gnome-config = import ./gnome-config-module.nix;
  #plasma-config = import ./plasma-config-module.nix;
  #i3-config = import ./i3-config.nix;
}