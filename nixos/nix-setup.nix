{ ... }:

{
  nixpkgs.config = {
    allowUnfree = true;
    permittedInsecurePackages = [ "electron-25.9.0" ];
  };

  nix = {
    optimise.automatic = true;
    settings = {
      max-jobs = 3;
      cores = 7; # uses 21 logical CPUs
      auto-optimise-store = true;

      experimental-features = [
        "nix-command" # Enables some useful tools like the `nix edit '<nixpkgs>' <some-package-name>`
        "flakes"
      ];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };
  };
}

# Stuff to get self-compilation of the whole system with cpu-optimizations to work. I find this idea ridiculous now...
/*nix.settings.system-features = [ "benchmark" "big-parallel" "kvm" "nixos-test" "gccarch-raptorlake" "gccarch-x86-64-v3"];
  nixpkgs.localSystem = {
  gcc.arch = "raptorlake";
  gcc.tune = "raptorlake";
  #gcc.arch = "x86-64-v3";
  #gcc.tune = "x86-64-v3";
  system = "x86_64-linux";
};*/

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
