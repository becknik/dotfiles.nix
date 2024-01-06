{ flakeDirectory, defaultUser, pkgs, ... }:

{
  # Auto Upgrade Systemd Service

  ## Post Auto Upgrade Systemd Services
  systemd.services =
    let
      nixosUpgradeNotifySend = { message, critical }: {
        #wantedBy = [ "multi-user.target" ];
        description = "NixOS Upgrade Notification";
        serviceConfig = {
          Type = "oneshot";
          User = defaultUser;
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

      # TODO nixos-fetch-and-switch-on-change systemd service seems to no start on boot?
      nixos-fetch-and-switch-on-change = {
        description = "Triggers the nixos-upgrade.service when the remote config git repo is != local";
        unitConfig = {
          After = "network.target";
        };

        serviceConfig = {
          Type = "oneshot";
        };
        path = with pkgs; [ git nixos-rebuild ];
        environment = {
          NIXOS_CONFIG_REPO_DIRECTORY = flakeDirectory;
        };
        script = ''
          cd $NIXOS_CONFIG_REPO_DIRECTORY

          git fetch
          local=$(git rev-parse main)
          remote=$(git rev-parse main@{upstream})
          if [ $local != $remote ]; then
            git pull
            nixos-rebuild --flake "$NIXOS_CONFIG_REPO_DIRECTORY#$NIXOS_CONFIGURATION_NAME" switch
          fi
        '';
        #
      };
    };

  system.activationScripts = {
    "create-'/var/log/nixos-upgrade'-directory" = "mkdir -p /var/log/nixos-upgrade";
  };
}
