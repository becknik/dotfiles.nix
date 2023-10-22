# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ lib, pkgs, ... }:

{
  imports = [
      ./hardware/desktop.nix # Formerly hardware-config.nix

      ./nix-setup.nix
      ./packages.nix # Installation of a few system packages
      ./gnome.nix # Addition of some kde tools, removal of bloat, etc.
      ./desktop-env.nix

      ./virtualisation.nix

      <home-manager/nixos>
  ];

  system.autoUpgrade.enable = true;

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Time
  time.timeZone = "Europe/Berlin";
  services.timesyncd.enable = true; # should be activated by default unless container

  # Locale Setup
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
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

  # Hardware
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
    useDHCP = lib.mkDefault true;
    networkmanager = {
      enable = true; # actually redundant due to gnome.core-os-services, but you never know...
      dns = "systemd-resolved";
      ethernet.macAddress = "stable";
      # networking.tempAddresses is properly set up by default
    };
  };
  services.resolved.enable = true; # systemd-resolved

  # Security & Secrets
  security.pam.services.gdm.enableGnomeKeyring = true;
  programs.firejail.enable = false; # TODO
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
  #services.clamav.daemon.enable = false; # Not considered necessary, because we're on NixOS :D

  # Shell Setup
  programs.zsh = {
    enable = true;
    syntaxHighlighting.enable = true; # TODO Should be enabled through home-manager, which somehow isn't available atm so...
    /*autosuggestions.enable = true; # home-manager
    ohMyZsh = {
      enable = true;
      plugins = [ "man" ];
      theme = "agnoster";
    };*/
  };
  users.defaultUserShell = pkgs.zsh;

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

  # Boot Process
  boot = {
    kernelPackages = pkgs.linux_xanmod_latest_custom; # use my impure linux-overlay
    tmp.useTmpfs = true; # for /tmp
    plymouth = {
      enable = true;
      theme = "breeze";
    };
  };

  ## sysctl
  boot.kernel.sysctl = {
    # TODO https://documentation.suse.com/sles/15-SP3/html/SLES-all/cha-tuning-memory.html https://docs.kernel.org/admin-guide/sysctl/vm.html
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

  ## systemd

  ### journald
  # source: https://man7.org/linux/man-pages/man5/journald.conf.5.html
  services.journald.extraConfig =
    # Initialized with 10% of the respective file system
    "SystemMaxUse=2G\n"
    # Initalized with 4G
    + "RuntimeMaxFileSize=128M";

  ### logind # TODO
  # source: https://man7.org/linux/man-pages/man5/logind.conf.5.html

  ## Automatic User Login
  services.xserver.displayManager.autoLogin.enable = true;
  services.xserver.displayManager.autoLogin.user = "jnnk";
  # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  # Firewall
  networking.nftables.enable = true; # TODO might (according to wiki) cause trouble with docker and libvirt
  networking.firewall.enable = true;
  ## Firewall Ports to open
  networking.firewall.allowedTCPPorts = [ ];
  networking.firewall.allowedUDPPorts = [ ];
  services.avahi.openFirewall = true;
  services.samba.openFirewall = true;

  # System Versioning
  system.stateVersion = "23.05";

  # Home-Manager (NixOS-Module)
  # For standalone home-manager usage with this repo:
  # 1) Link to local users `~.config/home-manager/home.nix`
  # 2) Install home-manager standalone via `nix-shell '<home-manager>' -A install`
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;

    sharedModules = [
      <sops-nix/modules/home-manager/sops.nix>
    ];

    users.jnnk = import /home/jnnk/.config/home-manager/home.nix;
  };
}
