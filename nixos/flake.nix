{
  description = "A very basic flake";

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

    /*plasma-manager = {
      url = "github:pjones/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };*/
  };

  outputs = inputs@{ self, nixpkgs, nixpkgs-unstable, home-manager, sops-nix, /* plasma-manager, */ ... }: {
    nixosConfigurations = {
      dnix = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit nixpkgs-unstable; };

        modules = [
          ./configuration.nix

          # Home-Manager (NixOS-Module)
          # For standalone home-manager usage with this repo:
          # 1) Link to local users `~.config/home-manager/home.nix`
          # 2) Install home-manager standalone via `nix-shell '<home-manager>' -A install`
          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;

            home-manager.extraSpecialArgs = { inherit nixpkgs-unstable; };

            home-manager.sharedModules = [
              sops-nix.homeManagerModules.sops
              #plasma-manager.homeManagerModules.plasma-manager
            ];

            #home-manager.users.jnnk = import /home/jnnk/.config/home-manager/home.nix;
            home-manager.users.jnnk = import ../home-manager/home.nix;
          }
        ];
      };
    };
  };
}
