{ lib, config, pkgs, ... }:

let
  mac-app-util-src = pkgs.fetchFromGitHub {
    repo = "mac-app-util";
    owner = "hraban";
    rev = "master";
    # nix run --experimental-features 'nix-command flakes' nixpkgs#nix-prefetch-github -- hraban mac-app-util | grep sha
    hash = "sha256-2suxkQW7TQYFAmVAe5FqblcKpQvpH8gGgpGygxNBqRQ=";
  };
  mac-app-util = (pkgs.callPackage mac-app-util-src {}).default;
in {
  home.stateVersion = "23.11";

  # Home Manager needs a bit of information about you and the paths it should manage.
  home.username = "jbecker";
  home.homeDirectory = "/Users/jbecker";

  # Lets Home Manager install and manage itself.
  programs.home-manager.enable = true;

  imports = [
    ./packages.nix # Installation of User Packages
    ./desktop-env.nix # XDG, GTK-X, Systemd & everything in the desktop-env folder

    ./devel.nix
    ./media.nix
  ];

  home.activation.trampolineApps = lib.hm.dag.entryAfter [ "writeBoundary" ]
  ''
    fromDir="$HOME/Applications/Home Manager Apps"
    toDir="$HOME/Applications/Home Manager Trampolines"
    ${mac-app-util}/bin/mac-app-util sync-trampolines "$fromDir" "$toDir"
  '';

  # Adding `pkg.unstable` to access/ install unstable packages
  nixpkgs.config = {
    allowUnfree = true;
    packageOverrides = pkgs: {
      unstable = import <nixpkgs> {
        config = config.nixpkgs.config;
      };
    };
  };
}
