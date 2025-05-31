{
  pkgs,
  mkFlakeDir,
  userName,
  config,
  ...
}:

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

  environment.systemPackages = with pkgs; [
    efibootmgr
    cryptsetup
    openvpn
    nixvim
  ];
  environment.variables.EDITOR = "nvim";
}
