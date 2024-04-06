{ ... }:

{
  imports = [
    ./plasma.nix
  ];

  # Folder Setup
  home.file = {

    ## devel Folder Structure
    "foreign" = {
      target = "devel/foreign/.keep"; # path relative to home
      text = "";
    };
    "own" = {
      target = "devel/own/.keep";
      text = "";
    };
    "ide" = {
      target = "devel/ide/.keep";
      text = "";
    };
    "lab" = {
      target = "devel/lab/.keep";
      text = "";
    };

    "scripts" = {
      target = "scripts/.keep";
      text = "";
    };

    ## Nextcould Sync Folders
    "nextcloud/uni" = {
      target = "nextcloud/uni/.keep";
      text = "";
    };
    "nextcloud/archive" = {
      target = "nextcloud/archive/.keep";
      text = "";
    };
    "nextcloud/transfer" = {
      target = "nextcloud/transfer/.keep";
      text = "";
    };

    ## sops .config folder where the keys.txt should live in to decrypt the secrets of sops-nix
    "sops" = {
      target = ".config/sops/age/.keep";
      text = "";
    };

    # Files

    "ghci" = {
      target = ".ghci";
      # prompt styling source: https://stackoverflow.com/a/53109980
      source = ./files/.ghci;
    };

    "cargo-config" = {
      target = ".cargo/config";
      source = ./files/cargo.toml;
    };

    "keepassxc-config" = {
      target = ".config/keepassxc/keepassxc.ini";
      source = ./files/keepassxc.ini;
    };
  };
}
