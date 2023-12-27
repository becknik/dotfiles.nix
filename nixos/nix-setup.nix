{ pkgs, ... }:

{
  nix = {
    optimise.automatic = true;
    settings = {
      max-jobs = 3;
      cores = 6; # with 7 the DE sometimes gets really unresponsive with CPU-usage up of 2400%
      auto-optimise-store = true;

      experimental-features = [
        "nix-command" # Enables some useful tools like the `nix edit '<nixpkgs>' <some-package-name>`
        "flakes"
      ];

      system-features = [ "nixos-test" "benchmark" "big-parallel" "kvm" ]
        # Source: https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/config/nix.nix
          ++ [ "gccarch-alderlake" ];
        # TODO alderlake flag is available in GCC 13.1, but not sure how to change the system env compiler from gcc (12.3.1) to gcc13...
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };
  };

  environment.systemPackages = with pkgs; [
    nix-tree
  ];
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
