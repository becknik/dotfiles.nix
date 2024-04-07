{ ... }:

{
  environment.variables."FLAKE_NIXOS_HOST" = "wnix";
  nix = {
    useDaemon = true;
    settings = {
      experimental-features = [
        "nix-command" # Enables some useful tools like the `nix edit '<nixpkgs>' <some-package-name>`
        "flakes"
      ];
    };

    gc.automatic = true;
    optimise.automatic = true;
  };

  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      cleanup = "zap";
      upgrade = true;
    };
    # nix packages sadly not working with x86_64-darwin
    casks = [ "logseq" "eloston-chromium" "firefox" ];
  };

  programs.zsh.enable = true;

  # not working in user-mode
  /* system.defaults = {
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
  }; */
}