{ pkgs, pkgs-unstable, nixvim, ... }:

{
  nixvim = nixvim.makeNixvimWithModule {
    pkgs = pkgs-unstable;

    module = ../nixvim;
    extraSpecialArgs = { };
  };

  # example = pkgs.callPackage ./example { };
}
