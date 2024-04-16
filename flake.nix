{
  description = "Moje konfigurace systemu ve vločkách";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs_old.url = "github:nixos/nixpkgs/nixos-23.11";

    # Home manager
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    hyprland.url = "github:hyprwm/Hyprland";
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs_old,
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
     # server
       halfofserver = nixpkgs.lib.nixosSystem {
         specialArgs = {inherit inputs outputs;};
         modules = [./halfofserver/nixos/configuration.nix];
       };
     # dílna
     # halfowork = nixpkgs.lib.nixosSystem {
     #   specialArgs = {inherit inputs outputs;};
     #   modules = [./halfofwork/nixos/configuration.nix];
     # };
     # notebook
       cihla = nixpkgs.lib.nixosSystem {
         specialArgs = {inherit inputs outputs;};
         modules = [./cihla/nixos/configuration.nix];
       };
       halfofraspberry = nixpkgs_old.lib.nixosSystem {
         specialArgs = {inherit inputs outputs;};
         modules = [./halfofraspberry/nixos/configuration.nix];
       };
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
     #    hyprland.homeManagerModules.default
     #    {wayland.windowManager.hyprland.enable = true;}
     #  };
        "halfarne@cihla" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
          extraSpecialArgs = {inherit inputs outputs;};
          # > Our main home-manager configuration file <
          modules = [./cihla/hm/home.nix];
         # hyprland.homeManagerModules.default
         # {wayland.windowManager.hyprland.enable = true;}
        };

      "halfarne@halfofraspberry" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.aarch64-linux; # Home-manager requires 'pkgs' instance
        extraSpecialArgs = {inherit inputs outputs;};
        # > Our main home-manager configuration file <
        modules = [./halfofraspberry/hm/home.nix]; #home-manager --extra-experimental-features "nix-command flakes auto-allocate-uids impure-env" switch --flake ./#halfarne@halfofraspberry
      };
    };
  };
}
