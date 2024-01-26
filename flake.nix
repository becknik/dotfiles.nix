{
  description = "NixOS/nix-darwin configurations for my desktop & laptops";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    darwin = {
      url = "github:lnl7/nix-darwin";
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

    # Libraries
    flockenzeit.url = "github:balsoft/Flockenzeit";

    # Non-Flake Inputs
    "ohmyzsh" = {
      url = "github:ohmyzsh/ohmyzsh";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, darwin, home-manager, nixos-hardware, ... }@input-attrs:
    let
      defaultUser = "jnnk";
      flakeDirectory = "/home/${defaultUser}/devel/own/dotfiles.nix";
      flakeLock = builtins.fromJSON (builtins.readFile ("${flakeDirectory}/flake.lock"));

      stateVersion = "23.11";

      system = "x86_64-linux";
      permittedInsecurePackages = [ "electron-25.9.0" ];
      # default nixpkgs config
      config = {
        inherit permittedInsecurePackages;
        allowUnfree = true;
        joypixels.acceptLicense = true;
      };
      defaultNixPkgsSetup = { inherit system config; };

      globalOverlayUnstable = final: prev: {
        unstable = import nixpkgs-unstable defaultNixPkgsSetup;
      };
      # For devices where no native building is set up
      globalOverlayCleanReplacement = final: prev: {
        clean = import nixpkgs defaultNixPkgsSetup;
      };

      specialArgs = {
        inherit stateVersion flakeDirectory flakeLock defaultUser;
        inherit (input-attrs) flockenzeit;
      };

      commonConfHomeManager = { laptopMode, pkgs, ... }:
        let
          additionalJDKs = with pkgs; [ temurin-bin-11 temurin-bin-17 ];
        in
        {
          home-manager = {
            extraSpecialArgs = specialArgs //
              {
                inherit laptopMode additionalJDKs system;
                inherit (input-attrs) ohmyzsh;
              };
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
      nixosConfigurations =
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

                  unstable = final: prev: {
                    # TODO might it be that unstable packages are not built optimized? :|
                    unstable = import nixpkgs-unstable defaultNixPkgsSetup // {
                      hostPlatform = platform;
                    };
                  };

                  ## Overlay to disable native compilation of packages with build flags
                  clean = final: prev: {
                    clean = import nixpkgs defaultNixPkgsSetup;
                  };

                  overlay-build-fixes = import ./overlays/build-fixes.nix module-attrs;

                  overlay-packages = import ./overlays/packages.nix module-attrs;
                in
                {
                  nixpkgs = defaultNixPkgsSetup // {
                    # https://nix.dev/tutorials/cross-compilation.html
                    #buildPlatform = platform; # platform where the executables are built
                    hostPlatform = platform; # platform where the executables will run

                    overlays = [
                      clean
                      unstable

                      overlay-packages.fasterStdenv

                      overlay-build-fixes.dependencyBuildSkip

                      overlay-build-fixes.deactivateFailingTestsPython
                      overlay-build-fixes.deactivateFailingTestsHaskell
                      overlay-build-fixes.deactivateFailingTests

                      overlay-packages.patched-linux-dnix
                      overlay-packages.patched-librewolf-unwrapped
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
              (
                { pkgs, ... }@module-attrs:
                commonConfHomeManager {
                  inherit pkgs;
                  laptopMode = false;
                }
              )
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
                nixpkgs = defaultNixPkgsSetup // {
                  overlays = [
                    globalOverlayUnstable
                    globalOverlayCleanReplacement
                    (import ./overlays/packages.nix module-attrs).patched-linux
                  ];
                };
              })
              input-attrs.disko.nixosModules.disko
              ./nixos
              ./nixos/lnix
              home-manager.nixosModules.home-manager
              (
                { pkgs, ... }@module-attrs:
                commonConfHomeManager {
                  inherit pkgs;
                  laptopMode = true;
                }
              )
            ];
          };
        };

      darwinConfigurations."wnix" =
        let
          system = "x86_64-darwin";
          defaultUser = "jbecker";
          specialArgs' = specialArgs // {inherit defaultUser;};
        in
        darwin.lib.darwinSystem {
          inherit system;

          modules = [
            ./nix-darwin
            home-manager.darwinModules.home-manager
            {
              home-manager = {
                extraSpecialArgs = specialArgs' //
                  {
                    inherit system;
                    inherit (input-attrs) ohmyzsh;
                  };

                useGlobalPkgs = true;
                useUserPackages = true;

                sharedModules = with input-attrs; [
                  nixvim.homeManagerModules.nixvim
                ];
                users.${defaultUser} = import ./nix-darwin/home-manager.nix;
              };
            }
          ];
        };
    };
}
