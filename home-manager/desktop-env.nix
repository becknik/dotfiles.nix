{ config, ... }:

{
  imports = [
    ./desktop-env/zsh.nix # zsh and oh-my-zsh config

    ./desktop-env/folders-and-files.nix # Creates my basic folder structure

    ./desktop-env/dconf.nix
  ];

  # Env
  home.sessionVariables = {
    EDITOR = "nvim";
    # Use gpg-agent instead of ssh-agent, which seems to be set before sourcing .zenv? Why? TODO
    # Former seems to be started automatically on every boot, so this value makes sure gpg-agent is used...
    SSH_AUTH_SOCK = ''"''${XDG_RUNTIME_DIR}/gnupg/S.gpg-agent.ssh"'';
  };

  # XDG
  xdg = {
    enable = true; # activates XDG user directory management
    cacheHome = "/tmp/cache-$USER/";
  };
  #home.packages = with pkgs; [ handlr-regex ]; # Doesn't work on NixOS :(

  gtk = {
    enable = true;
    gtk3 = {
      bookmarks = [
        "file:///home/jnnk/nextcloud/Uni/current-courses"
        "file:///home/jnnk/devel"
        "file:///home/jnnk/nextcloud"
      ];
      extraConfig = {
        gtk-recent-files-limit = 0;
        gtk-application-prefer-dark-theme = 0; # Sets "Legacy Applications" to "Adwaita-dark" theme
      };
      extraCss = # Minimizes the gtk-3 header-bar
''headerbar.default-decoration {
  padding-top: 5px;
  padding-bottom: 5px;
  min-height: 0px;
  font-size: 0.8em;
}'';
    };
    /*gtk4 = {
      extraConfig = {};
      extraCss = {};
    };*/
  };

  programs.kitty = {
    enable = true;
    darwinLaunchOptions = [
      "--single-instance"
    ];
    #keybindings
    settings = {
      scrollback_lines = 25000;
      enable_audio_bell = true;
      update_check_interval = 0;
    };
    theme = "Desert";
  };
}

# TODO Cache-persist script?
#[Unit]
#Description=Copy persisting cache files back to ~/.cache
#
#[Service]
#Type=oneshot
#ExecStart=/home/jnnk/scripts/cache-persist.sh start
#ExecStop=/home/jnnk/scripts/persist-cache.sh stop
#RemainAfterExit=yes
#
#[Install]
#WantedBy=default.target
