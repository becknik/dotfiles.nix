{ inputs, config, ... }:

{
  default = final: prev: {
    lib = prev.lib // {
      custom = rec {
        # Source: https://github.com/NixOS/nixpkgs/issues/41251
        pow = n: i:
          if i == 1 then n
          else if i == 0 then 1
          else n * pow n (i - 1)
        ;
      };
    };
  };

  nixpkgs-unstable = final: _prev: {
    unstable = import inputs.nixpkgs-unstable {
      inherit config;
      system = final.system;
    };
  };

  # Used to avoid building packages with local build config
  nixpkgs-clean = final: _prev: {
    clean = import inputs.nixpkgs {
      inherit config;
      system = final.system;
    };
  };

  # Brings in custom packages from '/pkgs'
  additions = final: _prev: import ../pkgs { pkgs = final; };

  modifications = (import ./modifications.nix { inherit inputs; });
  modifications-perf = (import ./modifications-perf.nix { inherit inputs; });

  build-fixes = import ./build-fixes.nix { inherit inputs; };

  build-skips = import ./build-skips.nix { inherit inputs; };

}
