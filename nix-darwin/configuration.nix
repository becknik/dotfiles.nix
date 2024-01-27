{ mac-app-util, pkgs, ... }:

{
  environment.variables."NIXOS_CONFIGURATION_NAME" = "wnix";
  nix.useDaemon = true;

  programs.zsh.enable = true;

  homebrew = {
    enable = false; # non-functional due to run as root...
    onActivation.autoUpdate = true; # updates homebrew packages on activation (can make darwin-rebuild much slower)
    casks = [
      "logseq"
    ];
  };

  # For system-wide, nix-darwin packages. This works because the
  # postActivation script is run after nix-darwin has aggregated all
  # .app links into a single directory, /Applications/Nix Apps.
  # TODO
  #system.activationScripts.postActivation.text = ''${mac-app-util}/bin/mac-app-util sync-trampolines "/Applications/Nix Apps" "/Applications/Nix Trampolines"'';

  system.defaults = {
    ## Optical Stuff
    universalaccess = {
      reduceTransparency = true;
      reduceMotion = true;
    };
    NSGlobalDomain = {
      NSAutomaticWindowAnimationsEnabled = false;
      NSScrollAnimationEnabled = true;
    };
    dock.launchanim = false;

    dock.autohide = true;
  };
}
