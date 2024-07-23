{ inputs, flockenzeit, mkFlakeDir, userName, config, pkgs, ... }:

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
          User = userName;
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
        serviceConfig =
          let
            currentDateTimeFormatted = with flockenzeit.lib.splitSecondsSinceEpoch { } inputs.self.sourceInfo.lastModified; "${F}-${T}";
            logFilePath = "file:/var/log/nixos-upgrade/${"${currentDateTimeFormatted}.log"}";
          in
          {
            StandardOutput = logFilePath;
            StandardError = logFilePath;

            Restart = "on-abort";
            # User = userName;
            # Group = "users";
          };
        onFailure = [ "nixos-upgrade-notify-send-failure.service" ];
        onSuccess = [ "nixos-upgrade-notify-send-success.service" ];
        postStop = ''chown -R ${userName}:users ${(mkFlakeDir userName config)}'';
      };

      nixos-upgrade-notify-send-success = (nixosUpgradeNotifySend {
        message = "Upgrade completed successfully";
        critical = false;
      });
      nixos-upgrade-notify-send-failure = (nixosUpgradeNotifySend {
        message = "Upgrade failed";
        critical = true;
      });

      nixos-upgrade-automatic-shutdown = {
        description = "Shutdown after nixos-upgrade.service (intended to be triggered manually)";
        after = [ "nixos-upgrade.service" ];
        #wantedBy = [ "nixos-upgrade.service" ];
        enable = true;
        serviceConfig = {
          ExecStart = "${pkgs.systemd}/bin/systemctl poweroff";
        };
      };

      nixos-upgrade-fetch-flake = {
        description = "Runs `nixos-rebuild` when flake upstream is ahead of local";
        wantedBy = [ "multi-user.target" ];
        wants = [ "network-online.target" ];
        after = [ "network-online.target" ];
        postStop = ''chown -R ${userName}:users ${(mkFlakeDir userName config)}'';

        serviceConfig = {
          Type = "oneshot";
          # User = userName; # TODO error: cannot run ssh: No such file or directory  fatal: unable to fork
          # Group = "users";
        };
        onFailure = [ "nixos-upgrade-notify-send-failure.service" ];

        path = with pkgs; [ git nixos-rebuild ];
        environment = {
          FLAKE = (mkFlakeDir userName config);
          FLAKE_NIXOS_HOST = config.environment.variables.FLAKE_NIXOS_HOST;
        };
        script = ''
          cd $FLAKE

          git fetch
          local_commit_date=$(git show -s --format=%ci main)
          remote_commit_date=$(git show -s --format=%ci main@{upstream})

          if [[ "$local_commit_date" < "$remote_commit_date" ]]; then
            echo "Detected changes in flake main@{upstream} from $remote_commit_date"
            echo "Trying to pull & checkout"

            git pull --rebase --autostash
            git switch main
            nixos-rebuild --flake "$FLAKE#$FLAKE_NIXOS_HOST" switch
          fi
          echo "No changes found in flake main@{upstream}"
        '';
      };
    };

  system.activationScripts = {
    "create-'/var/log/nixos-upgrade'-directory" = "mkdir -p /var/log/nixos-upgrade";
  };
}
