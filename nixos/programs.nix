{ pkgs, mkFlakeDir, userName, config, ... }:

{
  programs.git = {
    enable = true;
    config = {
      # Necessary for managing the flake in systemd & dnix scheduled `system.autoUpgrade` with `--commit-lock-file`
      safe.directory = (mkFlakeDir userName config);
      user = {
        name = "Nix Auto Upgrade";
        email = "jannikb@posteo.de";
      };
    };
  };

  services.pgadmin = {
    enable = true;
    initialEmail = "jannikb@posteo.de";
    initialPasswordFile = ./pgadmin-pw;
  };

  environment.systemPackages = with pkgs; [
    nixvim
    efibootmgr
    usbutils
    cryptsetup
    openvpn
  ];
}
