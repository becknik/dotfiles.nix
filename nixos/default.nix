{
  inputs,
  stateVersion,
  userName,
  config,
  lib,
  pkgs,
  isLaptop,
  ...
}:

{
  imports = [
    ./desktop-env # Setup of services for desktop-experience like sound, input, printing, ...
    ./programs.nix # Programs not fitting into desktop-env category

    ./systemd.nix # Systemd services (related to NixOS auto upgrade)
    ./virtualisation.nix
  ];

  # System Settings
  system = { inherit stateVersion; };

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
  services.chrony = {
    enable = true;
    enableNTS = true;
    serverOption = if isLaptop then "offline" else "iburst";
    servers = [
      "time.cloudflare.com"
      "ptbtime1.ptb.de"
      "ptbtime2.ptb.de"
      "ptbtime3.ptb.de"
      "ptbtime4.ptb.de"
    ];
  };

  # Locale Setup
  i18n =
    let
      en = "en_US.UTF-8";
      de = "de_DE.UTF-8";
    in
    {
      defaultLocale = en;
      extraLocaleSettings = {
        LC_ADDRESS = de;
        LC_IDENTIFICATION = de;
        LC_MEASUREMENT = de;
        LC_MONETARY = de;
        LC_NAME = de;
        LC_NUMERIC = de;
        LC_PAPER = de;
        LC_TELEPHONE = de;
        LC_TIME = en;
      };
    };

  # Common Hardware
  #hardware.enableAllFirmware = true;
  hardware.enableRedistributableFirmware = true;
  services.fstrim.interval = "weekly"; # enabled by nixos-hardware
  #services.hardware.bolt.enable = true; # implied by gnome.core-os-services
  hardware.sane.enable = true;

  hardware.bluetooth = {
    enable = true;
    # Shows battery charge of connected devices on supported
    settings.General.Experimental = true;
  };
  hardware.logitech.wireless.enable = true;
  hardware.logitech.wireless.enableGraphical = true;

  # Boot Process
  boot = {
    ## Shared Kernel Config
    extraModulePackages =
      with config.boot.kernelPackages;
      [
        turbostat

      ]
      ++ [ pkgs.system76-scheduler ];

    kernelParams = [
      "nowatchdog"
      "mitigations=off"
      "cryptomgr.notests"
      "fbcon=nodefer" # removes the manufacturer logo, might be necessary for plymouth
      "kvm.enable_virt_at_load=0" # required for virtualbox
    ];

    ## Etc.
    tmp = {
      useTmpfs = true; # for /tmp
      cleanOnBoot = true;
    };

    plymouth.enable = true;
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
    # Initialized with 10% of the file system
    "SystemMaxUse=200M\n"
    + "MaxRetentionSec=7d\n"
    +
      # Initialized with 4G
      "RuntimeMaxFileSize=128M";

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

  networking.nameservers = [
    "1.1.1.1#one.one.one.one"
    "1.0.0.1#one.one.one.one"
  ];
  services.resolved = {
    enable = true;
    dnssec = "true";
    domains = [ "~." ];
    fallbackDns = [
      "1.1.1.1#one.one.one.one"
      "1.0.0.1#one.one.one.one"
    ];
    dnsovertls = "true";
  };
  programs.openvpn3.enable = true;

  # Firewall
  networking.nftables.enable = true;
  services.firewalld =
    let
      tcp = port: [
        {
          port = port;
          protocol = "tcp";
        }
      ];

      tcpUdp = port: [
        {
          port = port;
          protocol = "tcp";
        }
        {
          port = port;
          protocol = "udp";
        }
      ];
    in
    {
      enable = true;

      services = {
        kdeconnect = {
          short = "KDE Connect";
          ports = tcpUdp {
            from = 1714;
            to = 1764;
          };
        };
        localsend = {
          short = "LocalSend";
          ports = tcpUdp 53317;
        };

        adb-wrieless = {
          short = "ADB Wireless";
          ports = tcp 5027;
        };
      };
      zones = {
        public = {
          services = [
            "kdeconnect"
            "localsend"

            "adb-wrieless"
          ];
        };
      };
    };
  services.samba.openFirewall = true;

  networking.firewall = {
    enable = true;
    backend = "firewalld";
    # TODO: necessary for proton vpn?
    # https://github.com/NixOS/nixpkgs/issues/307462#issuecomment-2750133149
    checkReversePath = "loose";
  };

  # Security & Secrets
  security = {
    sudo = {
      enable = true; # redundant
      execWheelOnly = true;
      extraConfig =
        "Defaults timestamp_type=global\n" # share sudo session between terminal sessions
        + "Defaults timestamp_timeout=20\n" # set sudo timeout from 10 to 20 minutes
        + "Defaults pwfeedback\n" # display stars when typing characters
        + "Defaults insults\n"
        #+ "Defaults editor=${pkgs.neovim}/bin/nvim";
        + "Defaults:root,%wheel env_keep+=EDITOR"; # Enables sudo-prepended programs like `systemctl edit ...` to use the specified default editor https://github.com/NixOS/nixpkgs/issues/276778
    };
    #please.enable = true; # Tool that enables executing a command as another user
  };

  services.pcscd.enable = true; # Must be running for age-plugin-yubikey
  security.pam.services.gdm.enableGnomeKeyring = true;

  services.dbus.apparmor = "enabled";
  security.apparmor.enable = true;
  environment.systemPackages = with pkgs; [
    firewalld-gui
    #firejail # if not included explicitly, `/etc/apparmor.d` wouldn't get symlinked...
  ];

  services.flatpak.enable = true;
  # Doesn't play with apparmor, therefore useless
  # $ sudo aa-enforce firejail-default
  # Can't find firejail-default in the system path list. ...
  programs.firejail = {
    enable = true;
    /*
      wrappedBinaries =
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
      };
    */
  };

  # Documentation
  documentation.man.generateCaches = true; # for `apropos` & `man -k` utilities

  # User Setup
  users.mutableUsers = false;
  users.users.${userName} = {
    isNormalUser = true;
    description = "jannik";
    hashedPassword = "$y$j9T$v2v24yeaoZcmnJRJqKVIb/$9/ERYx13TXXpCXA12dNvvrr1BOKx1/tgpO9M9fRlio4";
    extraGroups = [
      "wheel"
      "networkmanager"
      "libvirtd"
      "docker"
      "vboxusers"
      "video"
    ]
    ++ [
      "lp"
      "scanner"
    ];
    useDefaultShell = true;
  };
  users.users.root.hashedPassword = "!"; # disable root account

  # Shell Setup
  users.defaultUserShell = pkgs.zsh;
  programs.zsh = {
    enable = true;
    syntaxHighlighting.enable = true;
    autosuggestions.enable = true;
  };
  # Mix92-OS setup for more "pargmatic" NixOS:
  # https://fzakaria.com/2025/02/26/nix-pragmatism-nix-ld-and-envfs
  services.envfs.enable = false; # https://github.com/Mic92/envfs#envfs
  programs.nix-ld.enable = true;

  # Nix

  nix =
    let
      flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
    in
    {
      settings = {
        experimental-features = [
          "nix-command" # Enables some useful tools like the `nix edit '<nixpkgs>' <some-package-name>`
          "flakes"
        ];
        auto-optimise-store = true; # Automatic deduplication hard-linking in store
        # Opinionated: disable global registry
        flake-registry = "";
        # Workaround for https://github.com/NixOS/nix/issues/9574
        nix-path = config.nix.nixPath;

        trusted-users = [
          "root"
          userName
        ];
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

      # Opinionated: make flake registry and nix path match flake inputs
      registry = lib.mapAttrs (_: flake: { inherit flake; }) flakeInputs;
      nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;

      channel.enable = false;
      daemonCPUSchedPolicy = "idle"; # "other", "batch"
      daemonIOSchedClass = "idle"; # "best-effort"

      # https://discourse.nixos.org/t/why-does-nix-direnv-recommend-setting-nix-settings-keep-outputs/31081
      extraOptions = ''
        keep-outputs = true
      '';
    };
  services.angrr = {
    enable = true;
    enableNixGcIntegration = true;
  };

  # Avoids failing nix rebuilds due to too many open files
  environment.shellInit = "ulimit -n ${builtins.toString (pkgs.lib.custom.pow 2 16)}";

  catppuccin = {
    enable = true;
    flavor = "mocha";
  };
}
