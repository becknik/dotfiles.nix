{ config, pkgs, ... }:

{
  # Auto Upgrade Systemd Service
  system.autoUpgrade = {
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
      "-L" # print build logs
    ];
    dates = "weekly";
    randomizedDelaySec = "2h";
  };

  programs.git = {
    enable = true;
    config.user = {
      # Necessary for the `--commit-lock-file` option on config.system.autoUpgrade.flags
      email = "jannikb@posteo.de";
      name = "becknik";
    };
  };

  ## Post Auto Upgrade Systemd Services
  systemd.services =
    let
      nixosUpgradeNotifySend = { message, critical }: {
        #wantedBy = [ "multi-user.target" ];
        description = "NixOS Upgrade Notification";
        serviceConfig = {
          Type = "oneshot";
          User = "jnnk";
          Group = "users";
          ExecStart = "${pkgs.libnotify}/bin/notify-send "
            + "--urgency=${if critical then "critical --wait" else "normal --expire-time=10000"} "
            + "--icon='${pkgs.nixos-icons}/share/icons/hicolor/72x72/apps/nix-snowflake-white.png' "
            + "'NixOS Upgrade' '${message}'";
        };
        environment = {
          DBUS_SESSION_BUS_ADDRESS = "unix:path=/run/user/1000/bus"; # %U instead of 1000 fails
        };
      };
    in
    {
      nixos-upgrade = {
        environment = {
          NIXOS_UPGRADE_START_TIME = "$(date '+%Y-%m-%dT%R:%S%:z-%a')";
        };
        # TODO Systemd services' variable file names doesn't work, maybe try something like %i?
        serviceConfig = let log-file-location = "file:/var/log/nixos-upgrade/$NIXOS_UPGRADE_START_TIME"; in {
          StandardOutput = log-file-location;
          StandardError = log-file-location;
        };
        onFailure = [ "nixos-upgrade-notify-send-failure.service" ];
        onSuccess = [ "nixos-upgrade-notify-send-success.service" ];
        #After = [];
      };

      nixos-upgrade-automatic-shutdown = {
        description = "Automatic shutdown after nixos-upgrade.service";
        after = [ "nixos-upgrade.service" ];
        #wantedBy = [ "nixos-upgrade.service" ];
        enable = true;
        serviceConfig = {
          ExecStart = "${pkgs.systemd}/bin/systemctl poweroff";
        };
      };

      nixos-upgrade-notify-send-success = (nixosUpgradeNotifySend {
        message = "Upgrade completed successfully";
        critical = false;
      });
      nixos-upgrade-notify-send-failure = (nixosUpgradeNotifySend {
        message = "Upgrade failed";
        critical = true;
      });
    };

  system.activationScripts = {
    "create-'/var/log/nixos-upgrade'-directory" = "mkdir -p /var/log/nixos-upgrade";
  };
}
