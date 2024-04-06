{ inputs, mkFlakeDir, stateVersion, userName, config, lib, pkgs, ... }:

{
  imports = [
    ./packages.nix # Installation of a few system packages & browsers
    ./gnome.nix # Addition of some kde tools, removal of bloat, etc.
    ./desktop-env.nix # Setup of services for desktop-experience like sound, input, printing, ...

    ./systemd.nix # Systemd services (related to NixOS auto upgrade)
    ./virtualisation.nix
  ];


  # System Settings
  system = { inherit stateVersion; };
  programs.git = {
    enable = true;
    config = {
      # Necessary for managing the flake in systemd & dnix scheduled `system.autoUpgrade` with `--commit-lock-file`
      safe.directory = (mkFlakeDir userName config);
      user = {
        name = "Nix Auto Upgrade";
        email = "jannikb@posteo.de";
      };
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


  # Common Hardware
  #hardware.enableAllFirmware = true;
  hardware.enableRedistributableFirmware = true;
  services.fstrim.interval = "weekly"; # enabled by nixos-hardware
  #services.hardware.bolt.enable = true; # implied by gnome.core-os-services
  hardware.sane = {
    enable = true;
    dsseries.enable = true;
    brscan5 .enable = true;
    #extraBackends = [ pkgs.sane-backends ];
  };


  # Boot Process
  boot = {
    ## Shared Kernel Config
    extraModulePackages = with config.boot.kernelPackages; [
      system76-scheduler
      perf
      turbostat
      #opensnitch-ebpf # TODO this might cause kernel warning? - tool not really necessary
      #virtualbox # broken, see `virtualization.nix`
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

  environment.memoryAllocator.provider = "libc"; # "mimalloc" leads to various applications crashing


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

  networking.nameservers = [ "1.1.1.1#one.one.one.one" "1.0.0.1#one.one.one.one" ];
  services.resolved = {
    enable = true; # systemd-resolved
    #dnssec = "allow-downgrade";
    dnssec = "true";
    domains = [ "~." ];
    fallbackDns = [ "1.1.1.1#one.one.one.one" "1.0.0.1#one.one.one.one" ];
    #dnsovertls = "opportunistic";
    dnsovertls = "true";
  };
  #services.opensnitch.enable = true;
  programs.openvpn3.enable = true;
  # TODO configure openvpn config using sops-nix for passwords and config
  # https://nixos.wiki/wiki/OpenVPN
  /*services.openvpn.servers = {
    uniVPNv4Ov6 = { config = " config /root/nixos/openvpn/officeVPN.conf "; };
  };*/


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
  security.pam.services.gdm.enableGnomeKeyring = true;

  services.dbus.apparmor = "enabled";
  security.apparmor.enable = true;

  services.flatpak.enable = true;
  # Doesn't play with apparmor, therefore useless
  # $ sudo aa-enforce firejail-default
  # Can't find firejail-default in the system path list. ...
  programs.firejail = {
    enable = true;
    /* wrappedBinaries =
      let
        packagesToWrap = [ "librewolf" ]; # TODO "discord"

        packagesToWrap' = builtins.map
          (packageName: {
            ${packageName} = {
              executable = "${lib.getBin pkgs.${packageName}}/bin/${packageName}";
              profile = "${pkgs.firejail}/etc/firejail/${packageName}.profile";
            };
          })
          packagesToWrap;
        packagesToWrap'' = (builtins.foldl' (p1: p2: p1 // p2) { } packagesToWrap');
      in
      packagesToWrap'' // {
        ungoogled-chromium = {
          #executable = "${lib.getBin pkgs.ungoogled-chromium}/bin/chromium";
          executable = "/etc/per-user/jnnk/bin/chromium";
          profile = "${pkgs.firejail}/etc/firejail/chromium.profile";
          #extraArgs = "";
          #desktop = ""; .desktop file to modify. Only necessary if it uses the absolute path to the executable.
        };
      }; */
  };


  # User Setup
  users.mutableUsers = false;
  users.users.${userName} = {
    isNormalUser = true;
    description = "jannik";
    hashedPassword = "$y$j9T$v2v24yeaoZcmnJRJqKVIb/$9/ERYx13TXXpCXA12dNvvrr1BOKx1/tgpO9M9fRlio4";
    extraGroups = [ "wheel" "networkmanager" "libvirtd" /* "docker" */ "vboxusers" "video" ]
      # replaced docker with podman, docker wouldn't work rootless
      # printing & scanning:
      ++ [ "lp" "scanner" ];
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
  services.envfs.enable = false; # https://github.com/Mic92/envfs#envfs ( TODO `nil` not in path after this?!)


  # Nix

  # This will add each flake input as a registry
  # To make nix3 commands consistent with your flake
  nix.registry = (lib.mapAttrs (_: flake: { inherit flake; })) ((lib.filterAttrs (_: lib.isType "flake")) inputs);

  nix = {
    settings = {
      experimental-features = [
        "nix-command" # Enables some useful tools like the `nix edit '<nixpkgs>' <some-package-name>`
        "flakes"
      ];
      auto-optimise-store = true; # Automatic deduplication hardlinking in store
    };
    optimise = {
      automatic = true;
      dates = [ "20:00" ]; # Don't want it to run at 3:45
    };
    gc = {
      automatic = true;
      dates = "Fri";
      #options = "--delete-older-than 28d";
    };

    channel.enable = true; # false destroys some direnv `use nix` & oldschool nix-shell
    daemonCPUSchedPolicy = "idle"; # "other", "batch"

    # https://discourse.nixos.org/t/why-does-nix-direnv-recommend-setting-nix-settings-keep-outputs/31081
    extraOptions = ''
      keep-outputs = true
    '';
  };

  # Avoids faling nix rebuilds due to too many open files
  environment.shellInit = "ulimit -n ${builtins.toString (pkgs.lib.custom.pow 2 16)}";

  environment.systemPackages = with pkgs; [
    #opensnitch-ui
    #firejail # if not included explicitly, `/etc/apparmor.d` wouldn't get symlinked...
    #apparmor-parser # aa-enable firejail-default isn't working
  ];

  services.v4l2-relayd.instances = { }; # TODO proper camera setup
}
