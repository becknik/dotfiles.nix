{ userName, config, lib, pkgs, ... }:

{
  imports = [
    ../default.nix

    ../packages.nix
    ../desktop-env/shell.nix
    ../desktop-env/folders-and-files.nix # also want the `$HOME/devel/*` folder structure
    # TODO this also includes the manually created plasma config files...

    ../devel.nix
    ../secrets.nix
  ];

  home.homeDirectory = (lib.mkForce "/Users/${userName}"); # mkForce is necessary to prevent `/var/empty`

  # Settings changes from normal home-manager configuration
  services.gpg-agent.enable = (lib.mkForce false); # incompatible with darwin
  programs = {
    zsh = {
      oh-my-zsh.plugins = lib.mkAfter [
        "ssh-agent"
        "macos" # `showfiles` & `hidefiles` (in finder), `cdf` (cd to current finder directory)
      ];
      initExtra = "ssh-add --apple-load-keychain"; # load keys from previous sessions
    };
    # `ssh-add --apple-use-keychain ~/.ssh/<key>`
    ssh.extraConfig = "UseKeychain yes";
    librewolf.enable = lib.mkForce false;

    git = {
      userName = (lib.mkForce "Jannik Becker");
      userEmail = (lib.mkForce "sprinteins.becker@extaccount.com");
    };
  };

  # Packaging Leftovers
  xdg.enable = true;

  programs.gpg.enable = true;

  home.packages = with pkgs; [
    # media.nix leftovers
    ## Natural language
    hunspell
    hunspellDicts.de_DE

    ## Daily Software
    obsidian
    logseq
    # browser manged with brew

    ## Privacy
    keepassxc
    gpa
  ];
}
