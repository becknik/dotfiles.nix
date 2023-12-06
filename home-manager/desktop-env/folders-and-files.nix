{ config, ... }:

{
  # Folder Setup
  home.file = {

    ## devel Folder Structure
    "foreign" = {
      enable = true;
      target = "devel/foreign/.keep"; # path relative to home
      text = "";
    };
    "own" = {
      enable = true;
      target = "devel/own/.keep";
      text = "";
    };
    "work" = {
      enable = true;
      target = "devel/work/.keep";
      text = "";
    };
    "ide" = {
      enable = true;
      target = "devel/ide/.keep";
      text = "";
    };
    "lab" = {
      enable = true;
      target = "devel/lab/.keep";
      text = "";
    };

    "scripts" = {
      enable = true;
      target = "scripts/.keep";
      text = "";
    };

    ## Nextcould Sync Folders
    "nextcloud/uni" = {
      enable = true;
      target = "nextcloud/uni/.keep";
      text = "";
    };
    "nextcloud/archive" = {
      enable = true;
      target = "nextcloud/archive/.keep";
      text = "";
    };

    # Files

    ## oh-my-zsh
    "oh-my-zsh-custom-config-dir" = {
      enable = true;
      target = "${config.programs.zsh.oh-my-zsh.custom}/themes/bullet-train.zsh-theme";
      #text = ''''; # TODO
      source = "${config.home.homeDirectory}/devel/foreign/bullet-train.zsh/bullet-train.zsh-theme";
    };

    ## keepassxc default config
    "keepassxc-config" = {
      enable = true;
      target = ".config/keepassxc/keepassxc.ini";
      text =
''General]
ConfigVersion=2

[Browser]
CustomProxyLocation=
Enabled=true

[GUI]
ColorPasswords=true
HideUsernames=true
MinimizeOnClose=true
MinimizeOnStartup=true
MinimizeToTray=true
MonospaceNotes=true
ShowExpiredEntriesOnDatabaseUnlock=false
ShowTrayIcon=true
TrayIconAppearance=colorful

[PasswordGenerator]
AdditionalChars=
AdvancedMode=true
Braces=true
Dashes=true
EASCII=true
ExcludedChars=
Length=64
Logograms=true
Math=true
Punctuation=true
Quotes=true
SpecialChars=true

[Security]
IconDownloadFallback=true
LockDatabaseIdle=true'';
    };
  };
}