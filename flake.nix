{
  description = "flake for nixos, nix-darwin & more I've running on my desktop & laptops";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    devenv = {
      url = "github:cachix/devenv";
      inputs.nixpkgs.follows = "nixpkgs-unstable"; # requires > rustc-1.74.0
    };

    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    mac-app-util = {
      url = "github:hraban/mac-app-util";
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

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
    catppuccin.url = "github:catppuccin/nix";

    # Libraries
    flockenzeit.url = "github:balsoft/Flockenzeit";

    # Non-Flake Inputs
    "ohmyzsh" = {
      url = "github:ohmyzsh/ohmyzsh";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, darwin, home-manager, nixos-hardware, ... }@inputs:
    let
      systems = [ "x86_64-darwin" "x86_64-linux" ];
      forAllSystems = nixpkgs.lib.genAttrs systems;

      stateVersion = "23.11";

      # Necessary e.g. for NixOS `config.system.autoUpgrade.flake` with `--commit-lockfile`
      mkFlakeDir = userName: config: (if builtins.hasAttr "users" config then
        "${config.users.users.${userName}.home}/devel/own/dotfiles.nix" else
        "${config.home.homeDirectory}/devel/own/dotfiles.nix");

      # Default nixpkgs config
      config = {
        permittedInsecurePackages = [ "electron-25.9.0" ];

        allowUnfreePredicate = pkg: builtins.elem (nixpkgs.lib.getName pkg) [
          "brgenml1lpr"
          "brscan5"
          "brscan5-etc-files"
          "libsane-dsseries"
          "joypixels"

          "veracrypt"
          "obsidian"
          "discord"

          "steam"
          "steam-original"
          "steam-run"

          "postman"
          "jetbrains-toolbox"
          "idea-ultimate"
          "clion"
          "vscode-extension-MS-python-vscode-pylance"
          "vscode-extension-ms-vsliveshare-vsliveshare"
          "vscode-extension-github-copilot"
          "vscode-extension-github-copilot-chat"
        ];
        joypixels.acceptLicense = true;
      };

      # `nixpkgs-unstable'` varies between hosts due to target platform modification config on `dnix`
      defaultOverlays = { nixpkgs-unstable' ? self.overlays.nixpkgs-unstable }: with self.overlays; [
        default # Additions to `nixpkgs.lib`
        nixpkgs-unstable'
        modifications
        additions # contents of ./pkgs
      ];

      # Default system specialArgs
      args = userName: {
        # https://discourse.nixos.org/t/flakes-accessing-selfs-revision/11237/6
        inherit self inputs stateVersion userName mkFlakeDir;
        inherit (inputs) flockenzeit;
      };

      # home-manager config generation function
      mkHomeManagerConf = { system, laptopMode, userName, ... }:
        let
          isDarwinSystem = inputs.nixpkgs.lib.strings.hasInfix "darwin" system;
        in
        {
          home-manager = {
            extraSpecialArgs = (args userName) // {
              inherit (inputs) devenv;
              inherit system laptopMode isDarwinSystem;
            };
            useGlobalPkgs = true;
            useUserPackages = true;

            sharedModules = with inputs; [
              sops-nix.homeManagerModules.sops
              nix-index-database.hmModules.nix-index
              catppuccin.homeManagerModules.catppuccin
            ]
            ++ nixpkgs.lib.optional isDarwinSystem mac-app-util.homeManagerModules.default;

            # home-manager on darwin doesn't support all options
            users.${userName} = nixpkgs.lib.concatStringsSep "/" [
              ./home-manager
              "users"
              (if isDarwinSystem then "darwin.nix" else "nixos.nix")
            ];
          };
        };
    in
    {
      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixpkgs-fmt);

      # using standalone variant of nixvim to enable "bleeding edge" features & plugins, hence using systems with stateVersion=23.11
      packages = forAllSystems (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          pkgs-unstable = nixpkgs-unstable.legacyPackages.${system};
          nixvim = inputs.nixvim.legacyPackages.${system};
        in
        import ./pkgs { inherit pkgs pkgs-unstable nixvim; });

      overlays = import ./overlays { inherit inputs config; };

      #nixosModules = import ./modules/nixos;
      #homeManagerModules = import ./modules/home-manager;

      nixosConfigurations.dnix =
        let
          system = "x86_64-linux";
          userName = "jnnk";
        in
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = (args userName);

          modules = with nixos-hardware.nixosModules; [ common-cpu-intel common-pc common-pc-ssd ] ++ [
            inputs.disko.nixosModules.disko

            ./nixos
            ./nixos/dnix

            home-manager.nixosModules.home-manager
            (mkHomeManagerConf {
              inherit system userName;
              laptopMode = false;
            })

            # nixpkgs native build & overlay setup
            # https://nixos.wiki/wiki/Build_flags#Building_the_whole_system_on_NixOS
            ({ pkgs, ... }@module-inputs:
              let
                arch = "alderlake"; # TODO GCC13 -> "raptorlake"
                tune = arch;
                platform = {
                  inherit system;
                  gcc = { inherit arch tune; };
                  #rustc = { inherit arch tune; }; # TODO Research build flag attributes for rustc
                  # https://github.com/NixOS/nixpkgs/blob/master/pkgs/development/compilers/rust/rustc.nix
                };
                # https://nix.dev/tutorials/cross-compilation.html
                platformConfig = {
                  # https://github.com/NixOS/nixpkgs/issues/291271
                  #buildPlatform = platform; # platform where the executables are built
                  hostPlatform = platform; # platform where the executables will run
                };

                # TODO fastStdenv might not use arch flags if my thinkings not messed up...
                config' = {
                  replaceStdenv = { pkgs }: pkgs.fastStdenv;
                  #(pkgs.withCFlags [ "-O3" ] pkgs.fastStdenv);
                  # TODO error: The ‘env’ attribute set cannot contain any attributes passed to derivation.
                  # The following attributes are overlapping: NIX_CFLAGS_COMPILE
                } // config;
                # This for of adding `nixpkgs.config` is necessary due to `replaceStdenv` else shadowing the options
                # specified in `config`


                # Overlay Setup
                nixpkgs-unstable-with-platform = final: _prev: {
                  unstable = import nixpkgs-unstable
                    (platformConfig // {
                      inherit system;
                      config = config';
                      overlays = with self.overlays; [
                        default
                        modifications
                        modifications-perf
                        additions
                        nixpkgs-clean
                        build-fixes
                        build-skips
                      ];
                      # TODO error: attribute 'llvmPackages' missing?
                    });
                };
              in
              {
                nixpkgs = platformConfig // {
                  inherit system;
                  config = config';

                  overlays = (defaultOverlays { nixpkgs-unstable' = nixpkgs-unstable-with-platform; })
                    ++ (with self.overlays; [
                    modifications-perf
                    nixpkgs-clean
                    build-fixes
                    build-skips
                  ]);
                };
              })
            inputs.catppuccin.nixosModules.catppuccin
          ];
        };

      nixosConfigurations.lnix =
        let
          system = "x86_64-linux";
          userName = "jnnk";
        in
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = (args userName);

          modules = with nixos-hardware.nixosModules; [
            common-cpu-amd
            common-cpu-amd-pstate
            common-pc-laptop
            common-pc-laptop-ssd
            #common-pc-laptop-acpi_call # "acpi_call makes tlp work for newer thinkpads"
            asus-battery
          ] ++ [
            ({ lib, pkgs, ... }@module-inputs: {
              nixpkgs = {
                inherit system config;
                overlays = defaultOverlays { };
              };
            })
            inputs.disko.nixosModules.disko
            ./nixos
            ./nixos/lnix
            home-manager.nixosModules.home-manager
            (mkHomeManagerConf {
              inherit system userName;
              laptopMode = true;
            })
            inputs.catppuccin.nixosModules.catppuccin
          ];
        };

      darwinConfigurations."wnix" =
        let
          system = "x86_64-darwin";
          userName = "jbecker";
        in
        darwin.lib.darwinSystem {
          inherit system;
          specialArgs = (args userName);

          modules = [
            ({ lib, pkgs, ... }@module-inputs: {
              nixpkgs = {
                inherit system config;
                overlays = with self.overlays; [
                  (final: prev: {
                    unstable = import inputs.nixpkgs-unstable {
                      inherit config;
                      system = final.system;
                    };
                  })
                  # error: A definition for option `nixpkgs.overlays."[definition 1-entry 1]"' is not of type `nixpkgs overlay'. Definition values:
                  # - In `<unknown-file>'
                  #nixpkgs-unstable
                  default
                  modifications
                  additions
                ];
              };
            })
            inputs.mac-app-util.darwinModules.default
            ./darwin

            home-manager.darwinModules.home-manager
            (mkHomeManagerConf {
              inherit system userName;
              laptopMode = false; # no dconf <=> no effect
            })
          ];
        };

      devShell = forAllSystems
        (system:
          let
            pkgs = nixpkgs.legacyPackages.${system};
          in
          inputs.devenv.lib.mkShell {
            inherit inputs pkgs;
            modules = [
              ({ pkgs, config, ... }: {
                # https://devenv.sh/guides/using-with-flakes/
                # https://devenv.sh/reference/options/
                # https://github.com/expipiplus1/update-nix-fetchgit
                packages = [ pkgs.update-nix-fetchgit ];

                languages.nix.enable = true;

                pre-commit.hooks = {
                  nixpkgs-fmt.enable = true;
                };

                scripts.update-fetchgit.exec = builtins.readFile ./update-fetchgit.sh;
              })
            ];
          }
        );
    };
}
