{
  description = "Moje konfigurace systemu ve vločkách";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Home manager
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    hyprland.url = "github:hyprwm/Hyprland";

    # TODO: Add any other flake you might need
    # hardware.url = "github:nixos/nixos-hardware";

    # Shameless plug: looking for a way to nixify your themes and make
    # everything match nicely? Try nix-colors!
    # nix-colors.url = "github:misterio77/nix-colors";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    hyprland,
    ...
  } @ inputs: let
    inherit (self) outputs;
  in {
    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild --flake .#your-hostname'
    nixosConfigurations = {
      # hlavni PC
      halfofpc = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [./halfofpc/nixos/configuration.nix];
      };
     # # server
     # halfofserver = nixpkgs.lib.nixosSystem {
     #   specialArgs = {inherit inputs outputs;};
     #   modules = [./halfofserver/nixos/configuration.nix];
     # };
     # dílna
     # halfowork = nixpkgs.lib.nixosSystem {
     #   specialArgs = {inherit inputs outputs;};
     #   modules = [./halfofwork/configuration.nix];
     # };
    };

    # Standalone home-manager configuration entrypoint
    # Available through 'home-manager --flake .#your-username@your-hostname'
    homeConfigurations = {
      "halfarne@halfofpc" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
        extraSpecialArgs = {inherit inputs outputs;};
        # > Our main home-manager configuration file <
        modules = [
        ./halfofpc/hm/home.nix
        hyprland.homeManagerModules.default
        {wayland.windowManager.hyprland.enable = true;}
        ];
      };
     #  "pracant@halfofwork" = home-manager.lib.homeManagerConfiguration {
     #    pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
     #    extraSpecialArgs = {inherit inputs outputs;};
     #    # > Our main home-manager configuration file <
     #    modules = [./halfofwork/hm/home.nix];
     #  };
      "halfarne@halfofraspberry" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.aarch64-linux; # Home-manager requires 'pkgs' instance
        extraSpecialArgs = {inherit inputs outputs;};
        # > Our main home-manager configuration file <
        modules = [./halfofraspberry/hm/home.nix]; #home-manager --extra-experimental-features "nix-command flakes auto-allocate-uids impure-env" switch --flake ./#halfarne@halfofraspberry
      };
    };
  };
}
