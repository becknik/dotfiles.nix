# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix

    ./nix-setup.nix # Setup of nix & nixpkgs
    ./packages.nix # Installation of a few system packages
    ./gnome.nix # Addition of some kde tools, removal of bloat, etc.
    ./desktop-env.nix # Setup of services for desktop-experience like sound, input, printing, ...

    ./virtualisation.nix # virtualbox, libvirtd, podman containerization
  ];


  # System Settings
  system = {
    stateVersion = "23.11";
    autoUpgrade = {
      enable = true;
      operation = "boot";
      flake = "${config.users.users.jnnk.home}/devel/own/dotfiles.nix";
      flags = [
        "--commit-lock-file"
        "--update-input"
        "nixpkgs"
        "--update-input"
        "nixpkgs-unstable"
        "--update-input"
        "home-manager"
        "--update-input"
        "plasma-manager"
        "--update-input"
        "sops-nix"
      ];
      dates = "weekly";
      randomizedDelaySec = "2h";
    };
  };

  programs.git = {
    enable = true;
    config.user = { # Necessary for the `--commit-lock-file` option on config.system.autoUpgrade.flags
      email = "jannikb@posteo.de";
      name = "becknik";
    };
  };


  # Bootloader
  boot.loader = {
    timeout = 2;
    systemd-boot.enable = true;
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


  # Software for Hardware
  services = {
    #hardware.bolt.enable = true; # implied by gnome.core-os-services
    fstrim = {
      enable = true;
      interval = "weekly";
    };
    cpupower-gui.enable = true;
  };


  ## Networking
  networking = {
    hostName = "dnix"; # This has to be set, else the configuration will default to the hostname "nixos" in the flake.nix and won't build this system any more, unless #dnix is specified after the flake.nix URL...
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
  networking.firewall.enable = true;
  ## Firewall Ports to open
  networking.firewall.allowedTCPPorts = [ ];
  networking.firewall.allowedTCPPortRanges = [
    {
      from = 1714;
      to = 1764;
    }
  ];
  networking.firewall.allowedUDPPorts = [ ];
  networking.firewall.allowedUDPPortRanges = [
    {
      from = 1714;
      to = 1764;
    }
  ];
  services.avahi.openFirewall = true;
  services.samba.openFirewall = true;


  # Security & Secrets
  security = {
    sudo = {
      enable = true; # redundant
      execWheelOnly = true;
      extraConfig =
        "Defaults timestamp_type=global\n" # share sudo between terminals
        + "Defaults timestamp_timeout=15\n" # sudo timeout from 10 to 15 minutes
        + "Defaults pwfeedback\n" # display star when typing character
        + "Defaults insults";
    };
    please.enable = true; # Tool that enables executing a command as another user
  };

  services.pcscd.enable = true; # Must be running for age-plugin-yubikey
  programs.firejail.enable = false; # I'm not actively using this tool
  security.pam.services.gdm.enableGnomeKeyring = true;
  #services.clamav.daemon.enable = false; # Not considered necessary, because we're on NixOS :D


  # User Setup
  users.mutableUsers = false;
  users.users.jnnk = {
    isNormalUser = true;
    description = "jannik";
    hashedPassword = "$y$j9T$v2v24yeaoZcmnJRJqKVIb/$9/ERYx13TXXpCXA12dNvvrr1BOKx1/tgpO9M9fRlio4";
    extraGroups = [ "wheel" "networkmanager" "libvirtd" /* "docker" */ "vboxusers" "video" ];
    # replaced docker with podman, docker wouldn't work rootless
    useDefaultShell = true;
  };
  users.users.root.hashedPassword = "!";


  # Boot Process
  boot = {
    #kernelPackages = pkgs.linuxPackages_xanmod_latest;
    kernelPackages = pkgs.linux_xanmod_latest_patched;

    tmp = {
      useTmpfs = true; # for /tmp
      cleanOnBoot = true;
      # Source: https://github.com/NixOS/nixpkgs/issues/54707
      # The following only makes sense when building huge packages like the Linux kernel is failing with something like
      # `fatal error: error writing to /build/ccGD5Lsd.s: No space left on device`
      tmpfsSize = "90%"; # at least: max{linux-2023-11-25: 20G}
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

  ## Logind
  # TODO Logind config might be interesting for laptops https://man7.org/linux/man-pages/man5/logind.conf.5.html


  # Shell Setup
  programs.zsh = {
    enable = true;
    #syntaxHighlighting.enable = true; # Configured in home-manager
    #autosuggestions.enable = true; # "
  };
  users.defaultUserShell = pkgs.zsh;

}
