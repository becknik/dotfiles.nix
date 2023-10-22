{ pkgs, ... }:

{
  # JetBrains
  home.packages = with pkgs.jetbrains; [
    clion
    idea-ultimate
    #goland
  ];
}