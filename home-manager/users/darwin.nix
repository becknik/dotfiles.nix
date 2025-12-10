{
  mkFlakeDir,
  userName,
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ../default.nix

    ../packages.nix
    ../desktop-env/shell
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
      initContent = lib.mkAfter "ssh-add --apple-load-keychain"; # load keys from previous sessions
    };
    # `ssh-add --apple-use-keychain ~/.ssh/<key>`
    librewolf.enable = lib.mkForce false;

    git.extraConfig.safe.directory = mkFlakeDir userName config;
    # FIXME: currently having to copy-paste the secrets manually to the home directory; sops isn't working/ setup correctly?
    gpg.publicKeys = lib.mkForce (
      map
        (source: {
          inherit source;
          trust = 5;
        })
        [
          "${config.home.homeDirectory}/.gpg/becknik/public"
          "${config.home.homeDirectory}/.gpg/becknik/private"
        ]
    );
  };

  # Packaging Leftovers
  xdg.enable = true;

  programs.zsh.enable = true;
  # overwriting the sensible-default plugin
  programs.kitty.font.size = lib.mkForce 15;

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
    # keepassxc
  ];
}
