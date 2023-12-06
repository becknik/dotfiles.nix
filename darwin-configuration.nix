{ pkgs, ... }:

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
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    vim
    git
  ];

  # Use a custom configuration.nix location.
  # $ darwin-rebuild switch -I darwin-config=$HOME/.config/nixpkgs/darwin/configuration.nix
  # environment.darwinConfig = "$HOME/.config/nixpkgs/darwin/configuration.nix";

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  # nix.package = pkgs.nix;

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true;  # default shell on catalina
  # programs.fish.enable = true;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  # For system-wide, nix-darwin packages. This works because the
  # postActivation script is run after nix-darwin has aggregated all
  # .app links into a single directory, /Applications/Nix Apps.
  system.activationScripts.postActivation.text = ''${mac-app-util}/bin/mac-app-util sync-trampolines "/Applications/Nix Apps" "/Applications/Nix Trampolines"'';
}
