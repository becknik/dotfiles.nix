{ config, ... }:

{
  programs.gpg = {
    enable = true;
    publicKeys = [
      {
        source = "${config.home.homeDirectory}/.gnupg/private-keys-v1.d/gpg-personal";
        trust = 4;
      }
    ];
  };
}
