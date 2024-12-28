{
  description = "Your new nix config";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    # You can access packages and modules from different nixpkgs revs
    # at the same time. Here's an working example:
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    # Also see the 'unstable-packages' overlay at 'overlays/default.nix'.

    # Home manager
    home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    plasma-manager = {
      url = "github:pjones/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    # TODO: Add any other flake you might need
    # hardware.url = "github:nixos/nixos-hardware";

    # Shameless plug: looking for a way to nixify your themes and make
    # everything match nicely? Try nix-colors!
    nix-colors.url = "github:misterio77/nix-colors";
    catppuccin.url = "github:catppuccin/nix";
    nix-flatpak.url = "github:gmodena/nix-flatpak";

    distant.url = "github:myclevorname/distant"; # Temporary
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    hyprland,
    catppuccin,
    nix-flatpak,
    distant,
    ...
  } @ inputs: let
    inherit (self) outputs;
    # Supported systems for your flake packages, shell, etc.
    systems = [
      "aarch64-linux"
      "i686-linux"
      "x86_64-linux"
      #"aarch64-darwin"
      #"x86_64-darwin"
    ];
    # This is a function that generates an attribute by calling a function you
    # pass to it, with each system as an argument
    forAllSystems = nixpkgs.lib.genAttrs systems;
  in {
    # Your custom packages
    # Accessible through 'nix build', 'nix shell', etc
    packages = forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});
    # Formatter for your nix files, available through 'nix fmt'
    # Other options beside 'alejandra' include 'nixpkgs-fmt'
    formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);

    # Your custom packages and modifications, exported as overlays
    overlays = import ./overlays {inherit inputs;};
    # Reusable nixos modules you might want to export
    # These are usually stuff you would upstream into nixpkgs
    nixosModules = import ./modules/nixos;
    # Reusable home-manager modules you might want to export
    # These are usually stuff you would upstream into home-manager
    homeManagerModules = import ./modules/home-manager;

    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild --flake .#your-hostname'
    nixosConfigurations = {
      nixos-envy = nixpkgs.lib.nixosSystem {
        specialArgs = {hn = "envy"; inherit inputs outputs;};
        modules = with self.nixosModules; [
          # > Our main nixos configuration file <
          ./nixos/configuration.nix
        ];
      };
      nixos-zotac = nixpkgs.lib.nixosSystem {
        specialArgs = {hn = "zotac"; inherit inputs outputs;};
        modules = with self.nixosModules; [
          # > Our main nixos configuration file <
          ./nixos/configuration.nix
        ];
      };
      nixos-fax = nixpkgs.lib.nixosSystem {
        specialArgs = {hn = "fax"; inherit inputs outputs;};
        modules = with self.nixosModules; [
          nix-flatpak.nixosModules.nix-flatpak
          # > Our main nixos configuration file <
          ./nixos/configuration.nix
        ];
      };
    };

    # Standalone home-manager configuration entrypoint
    # Available through 'home-manager --flake .#your-username@your-hostname'
    homeConfigurations = {
      "donik@nixos-envy" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
        extraSpecialArgs = {hn = "envy"; inherit inputs outputs hyprland distant;};
        modules = with self.homeManagerModules; [
          # > Our main home-manager configuration file <
          ./home-manager/home.nix
          catppuccin.homeManagerModules.catppuccin
        ];
      };
      "donik@nixos-zotac" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
        extraSpecialArgs = {hn = "zotac"; inherit inputs outputs hyprland distant;};
        modules = with self.homeManagerModules; [
          # > Our main home-manager configuration file <
          ./home-manager/home.nix
          catppuccin.homeManagerModules.catppuccin
        ];
      };
      "donik@nixos-fax" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
        extraSpecialArgs = {hn = "fax"; inherit inputs outputs hyprland distant;};
        modules = with self.homeManagerModules; [
          # > Our main home-manager configuration file <
          ./home-manager/home.nix
          catppuccin.homeManagerModules.catppuccin
          
          # inputs.plasma-manager.homeManagerModules.plasma-manager
          # ./home-manager/programs/plasma
        ];
      };
    };
  };
}