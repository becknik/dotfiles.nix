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
        "docker"
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

  ## Add Java Packages
  home.file = with pkgs; (builtins.listToAttrs (builtins.map
    (jdk: {
      name = ".jdks/jdk-${jdk.version}";
      value = { source = jdk; };
    })
    [ temurin-bin-8 temurin-bin-11 ]));


  programs.gpg.enable = true;

  home.packages = with pkgs; [
    iterm2

    # media.nix leftovers
    ## Natural language
    hunspell
    hunspellDicts.de_DE

    ## Daily Software
    obsidian

    ## Privacy
    keepassxc
    gpa

    # Build Tools
    kubernetes-helm
  ];
}
