{
  description = "flake for nixos, nix-darwin & more I've running on my desktop & laptops";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-darwin.url = "github:NixOS/nixpkgs/nixpkgs-25.05-darwin";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.93.2-1.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    devenv = {
      url = "github:cachix/devenv";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    darwin = {
      url = "github:LnL7/nix-darwin/nix-darwin-25.05";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };

    home-manager = {
      url = "github:becknik/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    mac-app-util = {
      url = "github:hraban/mac-app-util";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    catppuccin.url = "github:catppuccin/nix";

    # Libraries
    flockenzeit.url = "github:balsoft/Flockenzeit";
    # fork using ungoogled chromium
    nix-webapps.url = "github:becknik/nix-webapps";
    # Setting the browsers to unstable, just like I do in my home-manager derivation
    nix-webapps.inputs.nixpkgs.follows = "nixpkgs-unstable";

    # Other stuff
    ohmyzsh = {
      url = "github:ohmyzsh/ohmyzsh";
      flake = false;
    };
  };

  nixConfig = {
    extra-trusted-public-keys = "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=";
    extra-substituters = "https://devenv.cachix.org";
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-unstable,
      darwin,
      home-manager,
      nixos-hardware,
      ...
    }@inputs:
    let
      systems = [
        "aarch64-darwin"
        "x86_64-linux"
      ];
      forAllSystems = nixpkgs.lib.genAttrs systems;

      stateVersion = "25.05";

      # Necessary e.g. for NixOS `config.system.autoUpgrade.flake` with `--commit-lockfile`
      mkFlakeDir =
        userName: config:
        (
          if builtins.hasAttr "users" config then
            "${config.users.users.${userName}.home}/devel/own/dotfiles.nix"
          else
            "${config.home.homeDirectory}/devel/own/dotfiles.nix"
        );

      # Default nixpkgs config
      config = {
        permittedInsecurePackages = [
          "ventoy-gtk3-1.1.05"
          "yubikey-manager-qt-1.2.5"
        ];
        allowUnfreePredicate =
          pkg:
          builtins.elem (nixpkgs.lib.getName pkg) [
            "brgenml1lpr"
            "joypixels"
            "ventoy-gtk3"

            "veracrypt"
            "obsidian"
            "google-chrome"

            "steam"
            "steam-unwrapped"
            "steam-original"
            "steam-run"

            "jetbrains-toolbox"
            "idea-ultimate"
            "clion"

            # Only vscode extension used from official nixpkgs
            "vscode"
            "vscode-extension-github-copilot-chat"
            "vscode-extension-ms-vsliveshare-vsliveshare"
            "vscode-extension-mhutchie-git-graph"
            "vscode-extension-ms-python-vscode-pylance"
            "vscode-extension-github-copilot"
            "vscode-extension-ms-vscode-remote-remote-ssh"
            "vscode-extension-ms-vscode-remote-remote-containers"
          ];
        joypixels.acceptLicense = true;
      };

      # `nixpkgs-unstable'` varies between hosts due to target platform modification config on `dnix`
      defaultOverlays =
        {
          nixpkgs-unstable' ? self.overlays.nixpkgs-unstable,
        }:
        with self.overlays;
        [
          default # Additions to `nixpkgs.lib`
          nixpkgs-unstable'
          modifications
          additions # contents of ./pkgs
        ]
        ++ (with inputs; [
          nix-vscode-extensions.overlays.default
          nix-webapps.overlays.lib
        ]);

      # Default system specialArgs
      args = userName: {
        # https://discourse.nixos.org/t/flakes-accessing-selfs-revision/11237/6
        inherit
          self
          inputs
          stateVersion
          userName
          mkFlakeDir
          ;
        inherit (inputs) flockenzeit;
      };

      # home-manager config generation function
      mkHomeManagerConf =
        {
          system,
          isLaptop,
          userName,
          ...
        }:
        let
          isDarwinSystem = inputs.nixpkgs.lib.strings.hasInfix "darwin" system;
        in
        {
          home-manager = {
            extraSpecialArgs = (args userName) // {
              inherit system isLaptop isDarwinSystem;
            };
            useGlobalPkgs = true;
            useUserPackages = true;

            # enabled for all users, not just one:
            sharedModules =
              with inputs;
              [
                sops-nix.homeManagerModules.sops
                nix-index-database.hmModules.nix-index
                catppuccin.homeModules.catppuccin
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

      # using standalone variant of nixvim to enable "bleeding edge" features & plugins, hence nixos stable stateVersion
      packages = forAllSystems (
        system:
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [ inputs.nix-webapps.overlays.lib ];
            # overlays = builtins.attrValues inputs.nix-webapps.overlays;
          };
          pkgs-unstable = import nixpkgs-unstable { inherit system; };
          nixvim = inputs.nixvim.legacyPackages.${system};
        in
        import ./pkgs { inherit pkgs pkgs-unstable nixvim; }
      );

      overlays = import ./overlays { inherit inputs config; };

      #nixosModules = import ./modules/nixos;
      #homeManagerModules = import ./modules/home-manager;

      nixosConfigurations.dnix =
        let
          system = "x86_64-linux";
          userName = "jnnk";
          isLaptop = false;
        in
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = (args userName) // {
            inherit isLaptop;
          };

          modules =
            with nixos-hardware.nixosModules;
            [
              common-cpu-intel
              common-pc
              common-pc-ssd
            ]
            ++ [
              inputs.disko.nixosModules.disko
              inputs.lix-module.nixosModules.default

              ./nixos
              ./nixos/dnix

              home-manager.nixosModules.home-manager
              (mkHomeManagerConf {
                inherit system userName isLaptop;
              })

              inputs.catppuccin.nixosModules.catppuccin

              # DEPRECATED: nixpkgs native build & overlay setup
              # https://nixos.wiki/wiki/Build_flags#Building_the_whole_system_on_NixOS
              (
                { pkgs, ... }@module-inputs:
                let
                  arch = "alderlake"; # TODO "raptorlake"
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
                    unstable = import nixpkgs-unstable (
                      platformConfig
                      // {
                        inherit system;
                        config = config';
                        overlays = with self.overlays; [
                          default
                          modifications
                          modifications-perf
                          additions
                        ];
                      }
                    );
                  };
                in
                {
                  nixpkgs = # platformConfig //
                    {
                      inherit system;
                      config = config # '
                      ;

                      overlays =
                        (defaultOverlays {
                          # nixpkgs-unstable' = nixpkgs-unstable-with-platform;
                        })
                        ++ (with self.overlays; [ modifications-perf ]);
                    };
                }
              )
            ];
        };

      nixosConfigurations.lnix =
        let
          system = "x86_64-linux";
          userName = "jnnk";
          isLaptop = true;
        in
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = (args userName) // {
            inherit isLaptop;
          };

          modules =
            with nixos-hardware.nixosModules;
            [
              common-cpu-amd
              common-cpu-amd-pstate
              common-pc-laptop
              common-pc-laptop-ssd
              #common-pc-laptop-acpi_call # "acpi_call makes tlp work for newer thinkpads"
              asus-battery
            ]
            ++ [
              (
                { lib, pkgs, ... }@module-inputs:
                {
                  nixpkgs = {
                    inherit system config;
                    overlays = defaultOverlays { };
                  };
                }
              )
              inputs.disko.nixosModules.disko
              inputs.lix-module.nixosModules.default
              ./nixos
              ./nixos/lnix
              home-manager.nixosModules.home-manager
              (mkHomeManagerConf {
                inherit system userName isLaptop;
              })
              inputs.catppuccin.nixosModules.catppuccin
            ];
        };

      darwinConfigurations.wnix =
        let
          system = "aarch64-darwin";
          userName = "jnnk";
          isLaptop = true;
        in
        darwin.lib.darwinSystem {
          inherit system;
          specialArgs = (args userName);

          modules = [
            inputs.mac-app-util.darwinModules.default
            home-manager.darwinModules.home-manager

            (
              { lib, pkgs, ... }@module-inputs:
              {
                nixpkgs = {
                  inherit system config;
                  overlays = with self.overlays; [
                    (final: _prev: {
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
                    inputs.nix-vscode-extensions.overlays.default
                  ];
                };
              }
            )
            ./darwin

            home-manager.darwinModules.home-manager
            (mkHomeManagerConf {
              inherit system userName isLaptop;
            })
          ];
        };

      devShells = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          default = inputs.devenv.lib.mkShell {
            inherit inputs pkgs;
            modules = [
              (
                { pkgs, config, ... }:
                {
                  # https://devenv.sh/guides/using-with-flakes/
                  # https://devenv.sh/reference/options/
                  # https://github.com/expipiplus1/update-nix-fetchgit
                  packages = [ pkgs.update-nix-fetchgit ];

                  languages.nix.enable = true;

                  git-hooks.hooks = {
                    nixfmt-rfc-style.enable = true;
                  };

                  scripts.update-fetchgit.exec = builtins.readFile ./update-fetchgit.sh;
                }
              )
            ];
          };
        }
      );
    };
}
