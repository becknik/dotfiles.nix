{
  description = "Flake configuration of NixOS for dnix (desktop)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    plasma-manager = {
      url = "github:pjones/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    nixvim = {
      url = "github:nix-community/nixvim/nixos-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = input-attrs@{ self, nixpkgs, nixpkgs-unstable, home-manager, sops-nix, plasma-manager, nixvim, ... }:
  let
    overlay-unstable = final: prev: {
      unstable = nixpkgs-unstable.legacyPackages.${prev.system};
      # unstable = import nixpkgs-unstable { # TODO Couldn't get this working
      #   inherit system;
      #   config.allowUnfree = true;
      # };
    };
  in {
    nixosConfigurations = {
      dnix = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        #specialArgs = { inherit nixpkgs-unstable; };

        modules = [
          # Enables pkgs.unstable
          ({ ... }: { nixpkgs.overlays = [ overlay-unstable ]; })

          # NixOS configuration
          ./configuration.nix

          # home-manager basic setup & configuration import
          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;

            home-manager.sharedModules = [
              sops-nix.homeManagerModules.sops
              plasma-manager.homeManagerModules.plasma-manager
              nixvim.homeManagerModules.nixvim
            ];

            home-manager.users.jnnk = import ../home-manager/home.nix; # flakes are git-repo-root & symlink-aware
          }
        ];
      };
    };
  };
}
