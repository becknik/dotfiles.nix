{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nixpkgs-stable.follows = ""; # https://github.com/Mic92/sops-nix/issues/353
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

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, nixos-hardware, ... }@input-attrs:
    {
      nixosConfigurations =
        let
          defaultUser = "jnnk";
          flakeDirectory = "/home/${defaultUser}/devel/own/dotfiles.nix";

          stateVersion = "23.11";

          system = "x86_64-linux";
          permittedInsecurePackages = [ "electron-25.9.0" ];
          # defaultNixpkgs...
          config = {
            inherit permittedInsecurePackages;
            allowUnfree = true;
            joypixels.acceptLicense = true;
          };

          global-overlay-unstable = final: prev: {
            unstable = import nixpkgs-unstable { inherit system config; };
          };
          # For devices where no native building is set up
          global-overlay-clean-replacement = final: prev: {
            clean = import nixpkgs { inherit system config; };
          };

          specialArgs = {
            inherit stateVersion flakeDirectory defaultUser;
          };

          common-conf-home-manager = { laptopMode, ... }: {
            home-manager = {
              extraSpecialArgs = specialArgs // { inherit laptopMode; };
              useGlobalPkgs = true;
              useUserPackages = true;

              sharedModules = with input-attrs; [
                sops-nix.homeManagerModules.sops
                plasma-manager.homeManagerModules.plasma-manager
                nixvim.homeManagerModules.nixvim
              ];

              users.${defaultUser} = import ./home-manager;
            };
          };
        in
        {
          dnix = nixpkgs.lib.nixosSystem {
            inherit system specialArgs;

            modules = with nixos-hardware.nixosModules; [
              common-cpu-intel
              common-pc
              common-pc-ssd
            ] ++ [
              # nixpkgs, native building & overlay setup
              (
                { pkgs, lib, ... }@module-attrs:
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

                  unstable = final: prev: { # TODO might it be that unstable packages are not built optimized? :|
                    unstable = import nixpkgs-unstable {
                      inherit system config;
                      hostPlatform = platform;
                    };
                  };

                  ## Overlay to disable native compilation of packages with build flags
                  clean = final: prev: {
                    clean = import nixpkgs { inherit system config; /* hostPlatform = prev.hostPlatform // { gcc = { }; }; */ };
                  };

                  build-fixes = import ./overlays/build-fixes.nix system;

                  packages = import ./overlays/packages.nix module-attrs;
                in
                {
                  nixpkgs = {
                    inherit system config;

                    # https://nix.dev/tutorials/cross-compilation.html
                    #buildPlatform = platform; # platform where the executables are built
                    hostPlatform = platform; # platform where the executables will run

                    overlays = [
                      clean
                      unstable

                      packages.default-to-faster-stdenv

                      build-fixes.dependency-build-skip

                      build-fixes.deactivate-failing-tests-python
                      build-fixes.deactivate-failing-tests-haskell
                      build-fixes.deactivate-failing-tests-normal-packages

                      packages.patched-linux
                      packages.patched-librewolf-unwrapped
                      #packages.obsidian
                    ];
                  };
                }
              )

              # NixOS configuration
              input-attrs.disko.nixosModules.disko
              ./nixos
              ./nixos/dnix

              # home-manager basic setup & configuration import
              home-manager.nixosModules.home-manager
              (common-conf-home-manager { laptopMode = false; })
            ];
          };

          lnix = nixpkgs.lib.nixosSystem {
            inherit system specialArgs;

            modules = with nixos-hardware.nixosModules; [
              common-cpu-amd
              common-cpu-amd-pstate
              common-pc-laptop
              common-pc-laptop-ssd
              #common-pc-laptop-acpi_call # "acpi_call makes tlp work for newer thinkpads"
              asus-battery
            ] ++ [
              ({ lib, pkgs, ... }@module-attrs: {
                nixpkgs = {
                  inherit system config;
                  overlays = [
                    global-overlay-unstable
                    global-overlay-clean-replacement
                    (import ./overlays/packages.nix module-attrs).patched-linux
                  ];
                };
              })
              input-attrs.disko.nixosModules.disko
              ./nixos
              ./nixos/lnix
              home-manager.nixosModules.home-manager
              (common-conf-home-manager { laptopMode = true; })
            ];
          };
        };
    };
}
