{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Rust
    cargo
    rustc

    # JVM
    kotlin
    jdk
    dotty # = scala 3

    # JS / TypeScript
    nodePackages.eslint_d
    nodejs_latest
    typescript

    # C++
    #unstable.gcc # TODO
    unstable.clang
    cmake
    lld
    lldb
    mold
  ];

  # JDK Setup TODO Add priority
  /*programs.java = {
    enable = true;
    package = pkgs.jdk17.overrideAttrs {
      meta.priorty = pkgs.
    };
  };*/

}