{ config, pkgs, ... }:

let
  createMailSecret = providerName: {
    "mail/${providerName}/address" = {
      sopsFile = ./secrets/mail.yaml;
      key = "${providerName}/address";
    };
    "mail/${providerName}/password" = {
      sopsFile = ./secrets/mail.yaml;
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
    secrets =
      {
        # NOTE: DON'T FORGET TO RUN `systemctl --user restart sops-nix.service` AFTER CHANGING THE CONFIGURATION OF ONE SECRET!!!

        # The name of the secret file in mount path which must be an element of this secrets sopsFile attribute
        # (or element of the defaultSopsFile, if it's set above)

        # Source: https://github.com/Mic92/sops-nix/blob/master/modules/home-manager/sops.nix
        "github-personal.pub" = {
          sopsFile = ./secrets/git.yaml;
          format = "yaml";
          key = "github/personal/ed25519.pub";
          path = "${config.home.homeDirectory}/.ssh/github-personal.pub";
        };
        "github-personal" = {
          sopsFile = ./secrets/git.yaml;
          key = "github/personal/ed25519";
          path = "${config.home.homeDirectory}/.ssh/github-personal";
        };

        "gitlab-personal" = {
          sopsFile = ./secrets/git.yaml;
          key = "gitlab/personal/ed25519";
          path = "${config.home.homeDirectory}/.ssh/gitlab-personal";
        };

        # Creation of secrets from binaries: `sops -e ./desktop-env/secrets/keepass.key > ./desktop-env/secrets/keepassxc.yaml`
        # The path must - likewise to the other secret files - match the golang regex-pattern from the `.sops` file

        "keepassxc.key" = {
          format = "binary";
          sopsFile = ./secrets/keepassxc.key;
        };

        "gpg-personal.asc" = {
          format = "binary";
          sopsFile = ./secrets/gpg-personal.asc;
          path = "${config.home.homeDirectory}/.gnupg/private-keys-v1.d/gpg-personal"; # Must be manually imported
        };

        # Mail Stuff
      }
      // mail-secret-posteo
      // mail-secret-gmx
      // mail-secret-uni;
  };
  systemd.user.services.sops-nix.Service.ExecStartPre = "${pkgs.coreutils}/bin/sleep 10";
  systemd.user.services.sops-nix.Unit.Wants = [
    "graphical-session.target"
    "gpg-agent.socket"
    "pcscd.socket"
  ];
  systemd.user.services.sops-nix.Unit.After = [
    "graphical-session.target"
    "gpg-agent.socket"
    "pcscd.socket"
  ];

  #systemd.user.services.gpg-agent.Unit.After = [ "sops-nix.service" ]; # Already set
  #systemd.user.services."app-org.keepassxc.KeePassXC@autostart.service".Unit.After = [ "sops-nix.service" ]; # disabled
  systemd.user.services.thunderbird.Unit.After = [ "sops-nix.service" ];
}
