{ pkgs, ... }:

{
  programs.gpg = {
    enable = true;
  };

  services.gpg-agent = {
    enable = true;
    enableSshSupport = false;
    enableZshIntegration = true;
    pinentry.package = pkgs.pinentry-gnome3;
    #sshKeys = {}; # Expose GPG-keys as SSH-keys
  };
}
