{ pkgs, ... }:

{
  programs.gpg.enable = true;

  # Package Leftover
  home.packages = with pkgs; [
    ## Natural language
    hunspell
    hunspellDicts.de_DE

    ## Daily Software
    unstable.obsidian
  
    ## Privacy
    keepassxc
    gpa
  ];
}