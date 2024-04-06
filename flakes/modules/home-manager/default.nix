# Add your reusable home-manager modules to this directory, on their own file (https://nixos.wiki/wiki/Module).
# These should be stuff you would like to share with others, not your personal configurations.
{
  # List your module files here
  # my-module = import ./my-module.nix;
  gaming = import ./gaming.nix;
  gnome-config = import ./gnome-config-module.nix;
  office = import ./office.nix;
  android = import ./android.nix;
}
