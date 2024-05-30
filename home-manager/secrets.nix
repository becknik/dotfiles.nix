{ config, ... }:

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
    # mount secrets to /run/user/<uid>/secrets which was
    defaultSymlinkPath = "%r/secrets";

    # Intentionally set to the default path for the sops (not sops-nix) executables private-keys search:
    age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
    # `cd home-manager && sops ./desktop-env/secrets/<some-secret>` and sops-nix now use the same private key file
    # The path of a secret must match the golang regex pattern in the `.sops` file

    #defaultSopsFile = ./secrets/git.yaml; # Useful if only one secret file is used

    # Secrets to be mounted under `/run/user/<you-uid>/secrets`:
    secrets = {

      # The name of the secret file in `/run/...`, which must be an element of this secrets sopsFile attribute
      # (or element of the defaultSopsFile, if it's set above)

      # Source: https://github.com/Mic92/sops-nix/blob/master/modules/home-manager/sops.nix
      "github-personal.pub" = {
        sopsFile = ./secrets/git.yaml;
        format = "yaml";
        key = "github/personal/ed25519.pub"; # "No tested [yaml]-data structures [apart from strings] are supported right now" - including directories?!
        /*symlink-*/ path = "${config.home.homeDirectory}/.ssh/github-personal.pub";
      };

      # DON'T FORGET TO RUN `systemctl --user restart sops-nix.service` AFTER CHANGING THE CONFIGURATION OF ONE SECRET!!!

      # TODO secrets are symlinked twice?!
      "github-personal" = {
        sopsFile = ./secrets/git.yaml;
        key = "github/personal/ed25519";
        path = "${config.home.homeDirectory}/.ssh/github-personal";
      };

      "gitlab-est.pub" = {
        sopsFile = ./secrets/git.yaml;
        key = "gitlab/est/ed25519.pub";
        path = "${config.home.homeDirectory}/.ssh/gitlab-est.pub";
      };
      "gitlab-est" = {
        sopsFile = ./secrets/git.yaml;
        key = "gitlab/est/ed25519";
        path = "${config.home.homeDirectory}/.ssh/gitlab-est";
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
    } // mail-secret-posteo // mail-secret-gmx // mail-secret-uni;
  };

  #systemd.user.services.gpg-agent.Unit.After = [ "sops-nix.service" ]; # Already set
  #systemd.user.services."app-org.keepassxc.KeePassXC@autostart.service".Unit.After = [ "sops-nix.service" ]; # disabled
  systemd.user.services.thunderbird.Unit.After = [ "sops-nix.service" ];
}
