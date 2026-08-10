{
  config,
  pkgs,
  lib,
  ...
}:

let
  createMailSecret = providerName: {
    "mail/${providerName}/address" = {
      sopsFile = ./mail.yaml;
      key = "${providerName}/address";
    };
    "mail/${providerName}/password" = {
      sopsFile = ./mail.yaml;
      key = "${providerName}/password";
    };
  };

  mail-secret-posteo = createMailSecret "posteo";
  mail-secret-gmx = createMailSecret "gmx";
  mail-secret-uni = createMailSecret "uni";
in
{
  # Sources:
  # https://github.com/Mic92/sops-nix
  # https://github.com/FiloSottile/age

  sops = {
    defaultSymlinkPath = "%r/secrets";
    age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
    # Secrets to be mounted:
    secrets = {
      # NOTE: DON'T FORGET TO RUN `systemctl --user restart sops-nix.service` AFTER CHANGING THE CONFIGURATION OF ONE SECRET!!!

      # The name of the secret file in mount path which must be an element of this secrets sopsFile attribute
      # (or element of the defaultSopsFile, if it's set above)

      # Source: https://github.com/Mic92/sops-nix/blob/master/modules/home-manager/sops.nix
      "ssh/github/becknik.pub" = {
        sopsFile = ./git.yaml;
        key = "github/becknik/public";
        path = "${config.home.homeDirectory}/.ssh/github-becknik.pub";
      };
      "ssh/github/becknik" = {
        sopsFile = ./git.yaml;
        key = "github/becknik/private";
        path = "${config.home.homeDirectory}/.ssh/github-becknik";
      };

      "ssh/gitlab/becknik.pub" = {
        sopsFile = ./git.yaml;
        key = "gitlab/becknik/public";
        path = "${config.home.homeDirectory}/.ssh/gitlab-becknik.pub";
      };
      "ssh/gitlab/becknik" = {
        sopsFile = ./git.yaml;
        key = "gitlab/becknik/private";
        path = "${config.home.homeDirectory}/.ssh/gitlab-becknik";
      };

      "gpg/becknik.pub" = {
        sopsFile = ./git.yaml;
        key = "becknik/public";
        path = "${config.home.homeDirectory}/.gpg/becknik";
      };
      "gpg/becknik.asc" = {
        sopsFile = ./git.yaml;
        key = "becknik/private";
      };

      # Creation of secrets from binaries: `sops -e ./desktop-env/gkeepass.key > ./desktop-env/secrets/keepassxc.yaml`
      # The path must - likewise to the other secret files - match the golang regex-pattern from the `.sops` file

      "keepassxc.key" = {
        format = "binary";
        sopsFile = ./keepassxc.key;
      };

      "gpg/mail/proton/main.pub" = {
        sopsFile = ./mail.yaml;
        key = "proton/main/public";
        path = "${config.home.homeDirectory}/.gpg/proton/main.pub";
      };
      "gpg/mail/proton/main.asc" = {
        sopsFile = ./mail.yaml;
        key = "proton/main/private";
      };
      "gpg/mail/proton/default.pub" = {
        sopsFile = ./mail.yaml;
        key = "proton/default/public";
        path = "${config.home.homeDirectory}/.gpg/proton/default.pub";
      };
      "gpg/mail/proton/default.asc" = {
        sopsFile = ./mail.yaml;
        key = "proton/default/private";
      };
      "gpg/mail/proton/official.pub" = {
        sopsFile = ./mail.yaml;
        key = "proton/official/public";
        path = "${config.home.homeDirectory}/.gpg/proton/official.pub";
      };
      "gpg/mail/proton/official.asc" = {
        sopsFile = ./mail.yaml;
        key = "proton/official/private";
      };

      "backup/neo/secret.pub" = {
        sopsFile = ./backup.yaml;
        key = "neo-backup/public";
      };
      "backup/neo/secret.asc" = {
        sopsFile = ./backup.yaml;
        key = "neo-backup/private";
      };
    }
    // mail-secret-posteo
    // mail-secret-gmx
    // mail-secret-uni;
  };

  programs.gpg.publicKeys =
    map
      (source: {
        inherit source;
        trust = 5;
      })
      [
        "${config.home.homeDirectory}/.gpg/becknik"
        "${config.home.homeDirectory}/.gpg/proton/main.pub"
        "${config.home.homeDirectory}/.gpg/proton/default.pub"
        "${config.home.homeDirectory}/.gpg/proton/official.pub"
      ];

  systemd.user.services.sops-nix = {
    Service = {
      ExecStartPre = [
        # Prevents this error on startup:
        # GDBus.Error:org.freedesktop.DBus.Error.ServiceUnknown: The name org.freedesktop.Notifications was not provided by any .service files
        "${pkgs.writeShellScript "sops-nix-start-pre-wait-for-notifications" ''
          if [ -z "$(${lib.getExe pkgs.yubikey-manager} list)" ]; then
            until ${pkgs.systemd}/bin/busctl --user list \
              | ${lib.getExe pkgs.ripgrep} -q org.freedesktop.Notifications; do
              ${pkgs.coreutils}/bin/sleep 1
            done
          fi
        ''}"
        # Make sure to wait for the YubiKey insertion before starting the service
        "${pkgs.writeShellScript "sops-nix-start-pre" ''
          if [ -z "$(${lib.getExe pkgs.yubikey-manager} list)" ]; then
            ${lib.getExe pkgs.libnotify} --urgency=critical --wait 'SOPS-Nix' 'Insert YubiKey to mount secrets...'
            if [ -z "$(${lib.getExe pkgs.yubikey-manager} list)" ]; then
              exit 1
            fi
          fi
        ''}"
      ];
      Environment = lib.mkForce "DBUS_SESSION_BUS_ADDRESS=unix:path=%t/bus";

      Restart = "on-failure";
      RestartSec = "10s";
    };
    Unit =
      let
        deps = [
          "dbus.socket"
          "gpg-agent.socket"
          "pcscd.socket"
        ];
      in
      {
        Wants = deps;
        After = deps;
      };
  };

  #systemd.user.services.gpg-agent.Unit.After = [ "sops-nix.service" ]; # Already set
  # systemd.user.services."app-org.keepassxc.KeePassXC@autostart.service".Unit.After = [ "sops-nix.service" ]; # disabled
  systemd.user.services.thunderbird.Unit.After = [ "sops-nix.service" ];
}
