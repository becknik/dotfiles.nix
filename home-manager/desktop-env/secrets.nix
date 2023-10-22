{ config, ... }:

{
  # Sources:
  # https://github.com/Mic92/sops-nix
  # https://github.com/FiloSottile/age

  sops = {
    # Source: https://github.com/Mic92/sops-nix/blob/master/modules/home-manager/sops.nix

    # Intentionally set to the default path for the sops (not sops-nix) executables private-keys search:
    age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
    # `cd home-manager && sops /desktop-env/secrets/<some-secret>` and sops-nix now use the same private key file
    # The path of a secret must match the golang regex pattern in the `.sops` file

    #defaultSopsFile = ./secrets/git.yaml; # Useful if only one secret file is used

    # Secrets to be mounted under `/run/user/<you-uid>/secrets`:
    secrets = {

      # The name of the secret file in `/run/...`, which must be an element of this secrets sopsFile attribute
      # (or element of the defaultSopsFile, if it's set above)

      githubPersonalPub = {
        sopsFile = ./secrets/git.yaml;
        format = "yaml";
        key = "github/personal/pub.ed25519"; # "No tested [yaml]-data structures [apart from strings] are supported right now" - even directories aren't?! # TODO
        mode = "0400";
        /*symlink-*/ path = "${config.home.homeDirectory}/.ssh/github_personal.pub";
      };

      # DON'T FORGET TO RUN `systemctl --user restart sops-nix.service` AFTER CHANGING THE CONFIGURATION OF ONE SECRET!!!

      githubPersonal = {
        sopsFile = ./secrets/git.yaml;
        key = "github/personal/.ed25519";
        path = "${config.home.homeDirectory}/.ssh/github_personal";
      };

      # Creation of secrets from binaries: `sops -e ./desktop-env/secrets/keepass.key > ./desktop-env/secrets/keepassxc.yaml`
      # The path must match the golang regex-pattern from the `.sops` file

      "keepassxc.key" = {
        format = "binary";
        sopsFile = ./secrets/keepassxc.yaml;
      };
    };
  };

}