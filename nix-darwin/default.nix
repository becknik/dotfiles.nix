{ pkgs, ... }:

{
  nix.useDaemon = true;

  programs.zsh.enable = true;

  homebrew = {
    enable = true;
    onActivation.autoUpdate = true; # updates homebrew packages on activation (can make darwin-rebuild much slower)
    casks = [
      "logseq"
    ];
  };

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
