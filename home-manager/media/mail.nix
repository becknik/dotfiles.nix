{ ... }:

let
  getSecretPasswordCommand = provider: "cat $XDG_RUNTIME_DIR/secrets/mail/${provider}/password";

  # `provider` should be a lower case string
  getDefaultMailAccountSettings = {
      provider,
      mailAddress,
      serverUsername ? provider
   }: let
    # Provides a `Provider` variable with the first letter uppercased
    /*
    firstProviderLetter = lib.substring 0 1 provider;
    restOfProvider = lib.substring 1 (lib.stringLength provider) provider;
    Provider = lib.concatStrings [(lib.toUpper firstProviderLetter) restOfProvider];
    */
   in {
    #name = Provider;
    /*
    error: The option `home-manager.users.jnnk.accounts.email.accounts.posteo.name' is read-only, but it's set multiple times. Definition values:
       - In `/nix/var/nix/profiles/per-user/root/channels/home-manager/modules/accounts/email.nix': "posteo"
       - In `/home/jnnk/.config/home-manager/media/mail.nix': "Posteo"
    */

    address = mailAddress; # Differing names necessary to avoid infinit recursion
    realName = "Jannik Becker";
    passwordCommand = getSecretPasswordCommand provider;

    userName = serverUsername;


    /*mbsync = {
      enable = true;
      create = "maildir";
    };*/
    aerc.enable = false;
    neomutt.enable = false;
    notmuch.enable = false;
  };
in {
  accounts.email.accounts = {

    "posteo" = (getDefaultMailAccountSettings {
      provider = "posteo";
      mailAddress = "jannikb@posteo.de";
    }) // {
      primary = true;
      aliases = [ "meinctutw@posteo.de" "spaeo@posteo.de" ];

      /*signature = {
        #command =
        #delimiter =
        #showSignature = "append";
        #text = "";
      };*/
      /*gpg = {
        key = ""; # TODO gpg --list-keys
        signByDefault = true;
      };*/

      #thunderbird.perIdentitySettings
      #thunderbird.settings # account settings
    };

    "gmx" = (getDefaultMailAccountSettings {
      provider = "gmx";
      mailAddress = "jannikb33@gmx.de";
    }) // {
      imap.host = "imap.gmx.net";
      smtp = {
        host = "mail.gmx.net";
        #port = 587;
      };
    };

    "uni" = (getDefaultMailAccountSettings {
      provider = "uni";
      mailAddress = "st177878@stud.uni-stuttgart.de";
      serverUsername = "st177878";
    }) // {
      imap.host = "imap.uni-stuttgart.de";
      smtp = {
        host = "smpt.uni-stuttgart.de";
        port = 587;
        tls.useStartTls = true; # TODO really?!
      };
    };
  };

  programs = {
    /*mbsync = {
      enable = true;
      #frequency ="*:0/1";
    };*/
    thunderbird = {
      enable = true;

      profiles."default" = {
        isDefault = true;
        withExternalGnupg = true;
      }; # this was necessary...

      settings = {
        "privacy.donottrackheader.enabled" = true;
      };
    };
  };
}