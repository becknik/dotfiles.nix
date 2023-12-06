{ pkgs, ... }:

{
  # JetBrains
  home.packages = with pkgs.jetbrains; [
    idea-ultimate
  ];
}