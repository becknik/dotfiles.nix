{ pkgs, ... }:

let
  secretPasswordCommand = provider: "cat $XDG_RUNTIME_DIR/secrets/mail/${provider}/password";

  # `provider` should be a lower case string to match the secrets
  mkDefaultMailAccountSettings =
    {
      provider,
      mailAddress,
      serverUsername ? mailAddress,
    }:
    {
      address = mailAddress;
      realName = "Jannik Becker";
      userName = serverUsername;
      # thunderbird doesn't use this (https://github.com/nix-community/home-manager/issues/4680#issuecomment-1869389857)
      passwordCommand = secretPasswordCommand provider;

      /*
        mbsync = {
          enable = true;
          create = "maildir";
        };
      */
      aerc.enable = false;
      neomutt.enable = false;
      notmuch.enable = false;

      thunderbird.enable = true;
      thunderbird.profiles = [ "default" ];
    };
in
{
  accounts.email.accounts = {
    "proton" =
      (mkDefaultMailAccountSettings {
        provider = "proton";
        mailAddress =
          with pkgs.lib;
          d pkgs (c [
            "YmVj"
            "a25p"
            "a0Bw"
            "cm90"
            "b24u"
            "bWU"
          ]);
      })
      // {
        primary = true;
        realName = "Jannik Becker";
        # TODO: doesn't seem to work with Thunderbird
        # gpg = {
        #   key = "43CFD745B4DB70B9";
        #   signByDefault = true;
        #   encryptByDefault = false;
        # };

        imap = {
          host = "127.0.0.1";
          port = 1143;
          tls.useStartTls = true;
        };
        smtp = {
          host = "127.0.0.1";
          port = 1025;
          tls.useStartTls = true;
        };

        aliases = with pkgs.lib; [
          (d pkgs (c [
            "YmVj"
            "a25p"
            "a0Bw"
            "bS5t"
            "ZQ"
          ]))
          (d pkgs (c [
            "amFu"
            "bmlr"
            "YjMz"
            "QHBt"
            "Lm1l"
          ]))
          (d pkgs (c [
            "Zmlu"
            "bmlr"
            "NkBw"
            "cm90"
            "b24u"
            "bWU"
          ]))
          (d pkgs (c [
            "c2g1"
            "a0Bw"
            "bS5t"
            "ZQ"
          ]))
          (d pkgs (c [
            "YmVj"
            "a25pa"
            "0Bwb"
            "S5tZ"
            "Q"
          ]))
        ];
      };

    "posteo" =
      (mkDefaultMailAccountSettings {
        provider = "posteo";
        mailAddress = "jannikb@posteo.de";
      })
      // {
        aliases = [
          "meinctutw@posteo.de"
          "spaeo@posteo.de"
        ];

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
        /*
          gpg = {
            key = "483342532448204D";
            signByDefault = true;
          };
        */

        signature = {
          #command =
          #delimiter =
          #showSignature = "append";
          #text = "";
        };

        #thunderbird.perIdentitySettings
        #thunderbird.settings # account settings
      };

    "gmx" =
      (mkDefaultMailAccountSettings {
        provider = "gmx";
        mailAddress = "jannikb33@gmx.de";
      })
      // {
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

    "uni" =
      (mkDefaultMailAccountSettings {
        provider = "uni";
        mailAddress = "st177878@stud.uni-stuttgart.de";
        serverUsername = "st177878";
      })
      // {
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
