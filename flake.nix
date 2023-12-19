{
  description = "NixOS configuration";

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

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, sops-nix, plasma-manager, nixvim, ... }@input-attrs:
    let system = "x86_64-linux";
    in
    {
      nixosConfigurations = {
        dnix = nixpkgs.lib.nixosSystem {
          inherit system;

          modules = [
            ({ config, pkgs, lib, ... }@module-attrs:
              let
                # Build Flags Setup (https://nixos.wiki/wiki/Build_flags#Building_the_whole_system_on_NixOS)

                arch = "alderlake"; # "raptorlake"
                tune = arch;

                platform = {
                  inherit system;
                  gcc = { inherit arch tune; };
                  #rustc = { inherit arch tune; }; # TODO Research build flag attributes for rustc
                  # https://github.com/NixOS/nixpkgs/blob/master/pkgs/development/compilers/rust/rustc.nix
                };

                # Overlay Setup

                ## Overlay to disable native compilation of packages with build flags
                clean-platform = final: prev: {
                  clean = import nixpkgs {
                    inherit system;
                    hostPlatform = {
                      gcc = { };
                      rustc = { };
                    };
                  };
                };

                build-fixes = import ./overlays/build-fixes.nix;

                packages = import ./overlays/packages.nix module-attrs;

                unstable = final: prev: {
                  unstable = import nixpkgs-unstable {
                    inherit system;
                    config.allowUnfree = true;
                  };
                };

              in
              {
                nixpkgs.config = {
                  allowUnfree = true;
                  permittedInsecurePackages =
                    lib.optional (pkgs.obsidian.version == "1.4.16") "electron-25.9.0";
                };

                nixpkgs = {
                  # https://nix.dev/tutorials/cross-compilation.html
                  #buildPlatform = platform; # platform where the executables are built
                  hostPlatform = platform; # platform where the executables will run
                };

                nixpkgs.overlays = [
                  unstable
                  clean-platform

                  build-fixes.don't-build-huge-packages

                  build-fixes.deactivate-tests-failing-python
                  build-fixes.deactivate-tests-redis
                  build-fixes.deactivate-tests-haskell

                  packages.patched-linux
                  #packages.obsidian
                ];
              })

            # NixOS configuration
            ./nixos/configuration.nix

            # home-manager basic setup & configuration import
            home-manager.nixosModules.home-manager
            {
              home-manager.extraSpecialArgs = {inherit system;}; # For if-else with "x86_64-linux"/darwin
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
