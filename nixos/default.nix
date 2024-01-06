{ stateVersion, flakeDirectory, defaultUser, config, lib, pkgs, ... }:

{
  imports = [
    ./packages.nix # Installation of a few system packages & browsers
    ./gnome.nix # Addition of some kde tools, removal of bloat, etc.
    ./desktop-env.nix # Setup of services for desktop-experience like sound, input, printing, ...

    ./systemd.nix # Systemd services (related to NixOS auto upgrade)
    ./virtualisation.nix

    ./browsers.nix
  ];


  # System Settings
  system = {
    inherit stateVersion;

    autoUpgrade = {
      enable = true;
      operation = "boot";
      flake = "${config.users.users.${defaultUser}.home}/devel/own/dotfiles.nix";
      flags = (builtins.map (flakeInput: "--update-input ${flakeInput}")
        [
          "nixpkgs"
          "nixpkgs-unstable"
          "nixos-hardware"
          "disko"
          "home-manager"
          "sops-nix"
          "plasma-manager"
          "nixvim"
        ]
      ) ++ [
        "-L" # print build logs
        "--commit-lock-file"
      ];
      dates = "Sat";
      randomizedDelaySec = "2h";
    };
  };
  programs.git = {
    enable = true; # Necessary for managing the flakes
    config = {
      # Necessary for systemd service fetching this git repo
      safe.directory = flakeDirectory;
    };
  };

  # Bootloader
  boot.loader = {
    timeout = 2;
    systemd-boot = {
      enable = true;
      editor = false;
      configurationLimit = 7;
    };
    efi.canTouchEfiVariables = true;
  };


  # Time
  time.timeZone = "Europe/Berlin";
  services.timesyncd.enable = true; # should be activated by default unless container

  # Locale Setup
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "de_DE.UTF-8";
      LC_IDENTIFICATION = "de_DE.UTF-8";
      LC_MEASUREMENT = "de_DE.UTF-8";
      LC_MONETARY = "de_DE.UTF-8";
      LC_NAME = "de_DE.UTF-8";
      LC_NUMERIC = "de_DE.UTF-8";
      LC_PAPER = "de_DE.UTF-8";
      LC_TELEPHONE = "de_DE.UTF-8";
      LC_TIME = "en_US.UTF-8";
    };
  };


  # Software for common Hardware
  services.fstrim.interval = "weekly"; # enabled by nixos-hardware
  #services.hardware.bolt.enable = true; # implied by gnome.core-os-services


  # Boot Process
  boot = {
    ## Shared Kernel Config
    extraModulePackages = with config.boot.kernelPackages; [
      system76-scheduler
      perf
      turbostat
    ];

    kernelParams = [
      "nowatchdog"
      "mitigations=off"
      "cryptomgr.notests"
      "fbcon=nodefer" # removes the manufacturer logo, might be necessary for plymouth
    ];

    ## Etc.
    tmp = {
      useTmpfs = true; # for /tmp
      cleanOnBoot = true;
    };

    plymouth = {
      enable = true;
      theme = "breeze";
    };
  };


  # Sysctl
  boot.kernel.sysctl = {
    # TODO Recherche on interesting sysctl options https://documentation.suse.com/sles/15-SP3/html/SLES-all/cha-tuning-memory.html https://docs.kernel.org/admin-guide/sysctl/vm.html
    #"vm.dirty_writeback_centisecs" = 1500;
    # Source: https://wiki.archlinux.org/title/Sysctl#Enable_TCP_Fast_Open
    "net.ipv4.tcp_fastopen" = 3;
    # Source: https://wiki.archlinux.org/title/Sysctl#Enable_BBR (which is enabled in linux-xanmod by default)
    #"net.core.default_qdisc" = "cake";
    #"net.ipv4.tcp_congestion_control" = "bbr";
    # ICMP Stuff
    "net.ipv4.icmp_echo_ignore_broadcasts" = 1;
    "net.ipv4.icmp_ignore_bogus_error_responses" = 1;
  };


  # Systemd

  ## Journald
  # source: https://man7.org/linux/man-pages/man5/journald.conf.5.html
  services.journald.extraConfig =
    # Initialized with 10% of the respective file system
    "SystemMaxUse=2G\n"
    # Initalized with 4G
    + "RuntimeMaxFileSize=128M";


  ## Networking
  networking = {
    useDHCP = lib.mkDefault true;
    networkmanager = {
      enable = true; # actually redundant due to gnome.core-os-services, but you never know...
      dns = "systemd-resolved";
      ethernet.macAddress = "stable";
      # networking.tempAddresses is properly set up by default
    };
  };

  services.resolved.enable = true; # systemd-resolved


  # Firewall
  networking.nftables.enable = true; # TODO NFTables might (according to wiki) cause trouble with docker and libvirt, test this out
  networking.firewall =
    let
      kdeConnectPortRange = { from = 1714; to = 1764; };
    in
    {
      enable = true;
      ## Firewall Ports to open
      allowedTCPPorts = [ ];
      allowedTCPPortRanges = [ kdeConnectPortRange ];
      allowedUDPPorts = [ ];
      allowedUDPPortRanges = [ kdeConnectPortRange ];
    };
  services.avahi.openFirewall = true;
  services.samba.openFirewall = true;


  # Security & Secrets
  security = {
    /* sudo = {
      enable = true; # redundant
      execWheelOnly = true;
      extraConfig =
        "Defaults timestamp_type=global\n" # share sudo session between terminal sessions
        + "Defaults timestamp_timeout=20\n" # set sudo timeout from 10 to 20 minutes
        + "Defaults pwfeedback\n" # display stars when typing characters
        + "Defaults insults\n"
        #+ "Defaults editor=${pkgs.neovim}/bin/nvim";
        + "Defaults:root,%wheel env_keep+=EDITOR"; # Enables sudo-prepended programs like `systemctl edit ...` to use the specified default editor https://github.com/NixOS/nixpkgs/issues/276778
        }; */
    #please.enable = true; # Tool that enables executing a command as another user
    sudo-rs = {
      enable = true;
      execWheelOnly = true;
      extraConfig = "Defaults env_keep+=EDITOR";
    };
  };

  services.pcscd.enable = true; # Must be running for age-plugin-yubikey
  programs.firejail.enable = false; # I'm not actively using this tool
  security.pam.services.gdm.enableGnomeKeyring = true;
  #services.clamav.daemon.enable = false; # Not considered necessary, because we're on NixOS :D


  # User Setup
  users.mutableUsers = false;
  users.users.${defaultUser} = {
    isNormalUser = true;
    description = "jannik";
    hashedPassword = "$y$j9T$v2v24yeaoZcmnJRJqKVIb/$9/ERYx13TXXpCXA12dNvvrr1BOKx1/tgpO9M9fRlio4";
    extraGroups = [ "wheel" "networkmanager" "libvirtd" /* "docker" */ "vboxusers" "video" ];
    # replaced docker with podman, docker wouldn't work rootless
    useDefaultShell = true;
  };
  users.users.root.hashedPassword = "!"; # disable root account


  # Shell Setup
  programs.zsh = {
    enable = true;
    #syntaxHighlighting.enable = true; # Configured in home-manager
    #autosuggestions.enable = true; # "
  };
  users.defaultUserShell = pkgs.zsh;


  # Nix
  nix = {
    settings = {
      experimental-features = [
        "nix-command" # Enables some useful tools like the `nix edit '<nixpkgs>' <some-package-name>`
        "flakes"
      ];

      auto-optimise-store = true;
    };

    optimise.automatic = true;
    gc = {
      automatic = true;
      dates = "Sun"; # 1 day after automatic system upgrade
      options = "--delete-older-than 14d";
    };
  };

  environment.systemPackages = with pkgs; [
    nix-tree
  ];
}
