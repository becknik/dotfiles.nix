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
      inputs.nixpkgs.follows = "nixpkgs-unstable"; # TODO ???
      inputs.nixpkgs-stable.follows = "nixpkgs";
    };

    plasma-manager = {
      url = "github:pjones/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    nixvim = {
      url = "github:nix-community/nixvim/nixos-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
      #inputs.pre-commit-hooks.inputs.nixpkgs-stable.follows = "nixpkgs"; # TODO Doesn't follows the nixvim inputs - bug report?
    };
  };

  outputs = input-attrs@{ self, nixpkgs, nixpkgs-unstable, home-manager, sops-nix, plasma-manager, nixvim, ... }:
    let
      current-system = "x86_64-linux";

      overlay-unstable = self: super: {
        unstable = import input-attrs.nixpkgs-unstable {
          system = current-system;
          config.allowUnfree = true;
        };
      };
    in
    {
      nixosConfigurations = {
        dnix = nixpkgs.lib.nixosSystem {
          system = current-system;
          specialArgs = { inherit current-system; };

          modules = [
            # Enables pkgs.unstable
            ({ config, pkgs, lib, ... }: {
              nixpkgs.overlays = [
                overlay-unstable

                (final: prev: {
                  # TODO Move overlays into separate file?
                  linux_xanmod_latest_custom = pkgs.linuxPackagesFor (pkgs.linux_xanmod_latest.override (old: {
                    # Optimizations
                    # TODO https://aur.archlinux.org/cgit/aur.git/tree/PKGBUILD?h=linux-clear
                    # Maybe interesting: https://discourse.nixos.org/t/overriding-nativebuildinputs-on-buildlinux/24934
                    stdenv = prev.impureUseNativeOptimizations prev.stdenv;
                    # Disable the Proton and Wine stuff
                    structuredExtraConfig = with lib.kernel; {
                      FUTEX = no;
                      FUTEX_PI = no;
                      WINESYNC = no;
                    };
                    # Disable programming language errors in the compilation-log
                    ignoreConfigErrors = true;
                  }));
                })
              ];
            })

            # NixOS configuration
            ./nixos/configuration.nix

            # home-manager basic setup & configuration import
            home-manager.nixosModules.home-manager
            {
              home-manager.extraSpecialArgs = { inherit current-system; };

              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;

              home-manager.sharedModules = [
                sops-nix.homeManagerModules.sops
                plasma-manager.homeManagerModules.plasma-manager
                nixvim.homeManagerModules.nixvim
              ];

              home-manager.users.jnnk = import ./home-manager/home.nix; # flakes are git-repo-root & symlink-aware
            }
          ];
        };
      };
    };
}
