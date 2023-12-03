{ config, lib, ... }:

{
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  nixpkgs.config = {
    allowUnfree = true;
  };

  nix.settings = {
    cores = 20; # leave 4 of my 24 logical CPUs free, useful for compilations
    auto-optimise-store = true;
    experimental-features = [
      "nix-command" # Enables some useful tools like the `nix edit '<nixpkgs>' <some-package-name>`
      "flakes" # TODO Figure out what this is and why I should waste even more time with this OS config...
    ];
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };

  # TODO Self-compilation of the whole system with optimizations
  /*nix.settings.system-features = [ "benchmark" "big-parallel" "kvm" "nixos-test" "gccarch-raptorlake" "gccarch-x86-64-v3"];
  nixpkgs.localSystem = {
    gcc.arch = "raptorlake";
    gcc.tune = "raptorlake";
    #gcc.arch = "x86-64-v3";
    #gcc.tune = "x86-64-v3";
    system = "x86_64-linux";
  };*/

  #programs.ccache.enable = false; # TODO Don't think that this is necessary for my purposes
  #sloppiness = locale,time_macros
  #cache_dir = /home/jnnk/.cache/ccache
  #max_size = 1.0G
}

# Arch Linux compilation flags setup
#CFLAGS="-march=native -O3 -pipe -fno-plt -fexceptions \
#        -Wp,-D_FORTIFY_SOURCE=2 -Wformat -Werror=format-security \
#        -fstack-clash-protection -fcf-protection"
#CXXFLAGS="$CFLAGS -Wp,-D_GLIBCXX_ASSERTIONS"
#LDFLAGS="-Wl,-O1,--sort-common,--as-needed,-z,relro,-z,now"
#LTOFLAGS="-flto=auto"
#RUSTFLAGS="-C opt-level=3 -C target-cpu=native"
#-- Make Flags: change this for DistCC/SMP systems
#MAKEFLAGS="-j12"