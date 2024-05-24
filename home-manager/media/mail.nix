{ ... }:

let
  secretPasswordCommand = provider: "cat $XDG_RUNTIME_DIR/secrets/mail/${provider}/password";

  # `provider` should be a lower case string to match the secrets
  mkDefaultMailAccountSettings = { provider, mailAddress, serverUsername ? mailAddress }:
    {
      address = mailAddress;
      realName = "Jannik Becker";
      userName = serverUsername;
      # thunderbird doesn't use this (https://github.com/nix-community/home-manager/issues/4680#issuecomment-1869389857)
      passwordCommand = secretPasswordCommand provider;

      /*mbsync = {
        enable = true;
        create = "maildir";
      };*/
      aerc.enable = false;
      neomutt.enable = false;
      notmuch.enable = false;

      thunderbird.enable = true;
      thunderbird.profiles = [ "default" ];
    };
in
{
  accounts.email.accounts = {

    "posteo" = (mkDefaultMailAccountSettings {
      provider = "posteo";
      mailAddress = "jannikb@posteo.de";
    }) // {
      primary = true;
      aliases = [ "meinctutw@posteo.de" "spaeo@posteo.de" ];

      smtp = {
        host = "posteo.de";
        port = 465;
        # tls.enable = true; # default
      };
      imap = {
        host = "posteo.de";
        port = 993;
      };

      # TODO get gpg signing & gpg setup working & right
      /* gpg = {
        key = "483342532448204D";
        signByDefault = true;
      }; */

      signature = {
        #command =
        #delimiter =
        #showSignature = "append";
        #text = "";
      };

      #thunderbird.perIdentitySettings
      #thunderbird.settings # account settings
    };

    "gmx" = (mkDefaultMailAccountSettings {
      provider = "gmx";
      mailAddress = "jannikb33@gmx.de";
    }) // {
      smtp = {
        host = "mail.gmx.net";
        port = 587;
        tls.useStartTls = true;
      };
      imap = {
        host = "imap.gmx.net";
        port = 993;
      };
    };

    "uni" = (mkDefaultMailAccountSettings {
      provider = "uni";
      mailAddress = "st177878@stud.uni-stuttgart.de";
      serverUsername = "st177878";
    }) // {
      imap = {
        host = "imap.uni-stuttgart.de";
        port = 993;
      };
      smtp = {
        host = "smtp.uni-stuttgart.de";
        port = 587;
        tls.useStartTls = true;
      };
    };
  };
}
