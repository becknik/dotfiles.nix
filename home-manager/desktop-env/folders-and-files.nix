{ ... }:

{
  imports = [
    ./plasma.nix
  ];

  # Folder Setup
  home.file =
    let
      mkKeepDirectory = path: { "${path}" = { target = path + "/.keep"; text = ""; }; };
    in
    (builtins.foldl' (acc: x: acc // mkKeepDirectory x) { } [
      "devel/foreign"
      "devel/own"
      "devel/ide"
      "devel/lab"
      "devel/work"
      "devel/uni"

      "nextcloud/uni"
      "nextcloud/archive"
      "nextcloud/transfer"

      "scripts"
      "vm"
      "vpn"
      # sops .config folder where the keys.txt should live in to decrypt the secrets of sops-nix
      ".config/sops/age"
    ]) //
    {
      "ghci" = {
        target = ".ghci";
        # prompt styling source: https://stackoverflow.com/a/53109980
        source = ./files/.ghci;
      };

      "config-cargo" = {
        target = ".cargo/config";
        source = ./files/cargo.toml;
      };

      "config-keepassxc" = {
        target = ".config/keepassxc/keepassxc.ini";
        source = ./files/keepassxc.ini;
      };
    };
}
