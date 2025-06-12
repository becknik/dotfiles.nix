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
        name = "NixOS Auto Upgrade";
        email =
          with pkgs.lib;
          d pkgs (c [
            "YmVj"
            "a25p"
            "a0Bw"
            "cm90"
            "b24u"
            "bWU"
          ]);
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
