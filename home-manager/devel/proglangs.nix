{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # JVM
    kotlin
  ];

  # JDK Setup TODO Add priority
  programs.java = {
    enable = true;
    package = pkgs.jdk17.overrideAttrs ( oldAttrs: {
      meta.priority = -10;
    });
  };
}
/*
https://discourse.nixos.org/t/fix-collision-with-multiple-jdks/10812
home.file."jdks/openjdk8".source = unstable.openjdk8;
home.file."jdks/oraclejdk8".source = unstable.oraclejdk8;
home.file."jdks/openjdk11".source = pkgs.openjdk11;
home.file."jdks/scala".source = pkgs.scala;
nixpkgs.overlays = [
  nur.repos.moaxcp.overlays.use-moaxcp-nur-packages
  nur.repos.moaxcp.overlays.use-latest
];
home.packages = with pkgs; let
  adoptopenjdk-hotspot-bin-11-low = adoptopenjdk-hotspot-bin-11.overrideAttrs(oldAttrs: {
    meta.priority = 10;
  });
in [
  adoptopenjdk-bin
  adoptopenjdk-hotspot-bin-11-low  ixpkgs.overlays = [
  nur.repos.moaxcp.overlays.use-moaxcp-nur-packages
  nur.repos.moaxcp.overlays.use-latest
];
home.packages = with pkgs; let
  adoptopenjdk-hotspot-bin-11-low = adoptopenjdk-hotspot-bin-11.overrideAttrs(oldAttrs: {
    meta.priority = 10;
  });
in [
  adoptopenjdk-bin
  adoptopenjdk-hotspot-bin-11-low
*/