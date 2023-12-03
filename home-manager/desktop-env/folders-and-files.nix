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
    "nextcloud/transfer" = {
      enable = true;
      target = "nextcloud/transfer/.keep";
      text = "";
    };

    ## sops .config folder where the keys.txt should live in to decrypt the secrets of sops-nix
    "sops" = {
      enable = true;
      target = "${config.programs.zsh.oh-my-zsh.custom}/.config/sops/age/.keep";
      text = '''';
    };

    # Files

    ## oh-my-zsh
/*     "oh-my-zsh-custom-config-dir" = { # TODO
      enable = true;
      target = "${config.programs.zsh.oh-my-zsh.custom}/themes/bullet-train.zsh-theme";
      #text = ''''; # TODO
      source = "${config.home.homeDirectory}/devel/foreign/bullet-train.zsh/bullet-train.zsh-theme";
    }; */

    ## The application-internal way of generating an `electron.desktop` file is wrong and incompatible with NixOS due to dangling symlinks...
    "element-desktop-autostart" = {
      enable = true;
      target = ".config/autostart/element.desktop";
      text =
''[Desktop Entry]
Type=Application
Version=1.0
Name=Element
Comment=Forcing element-desktop to start properly
Exec=element-desktop --hidden
StartupNotify=false
Terminal=false'';
    };

    "whatsapp-for-linux-autostart" = {
      enable = true;
      target = ".config/autostart/whatsapp-for-linux.desktop";
      text =
''[Desktop Entry]
Type=Application
Version=1.0
Name=Whatsapp
Comment=Fixing the autostart toggle of whatsapp-for-linux doing nothing at all
Exec=whatsapp-for-linux
StartupNotify=false
Terminal=false'';
    };


    ## cargo (target code optimization) config
    "cargo-config" = {
      enable = true;
      target = ".cargo/config";
      text =
''[target.x86_64-unknown-linux-gnu]
rustflags = ["-C", "target-cpu=native"]
'';
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
LockDatabaseIdle=true
'';
    };

    ## VM Script
    "vm-executer-script" = {
      enable = true;
      executable = true;
      target = "vm/run.sh";
      text =
''#!/bin/bash

KVM="-enable-kvm -machine q35 -device intel-iommu"	# virtio-serial-pc
HW="-m 4096 -smp 4 -cpu host"
AUDIO="-audiodev alsa,id=alsa,driver=alsa,out.buffer-length=500000,out.period-length=726"	# the heck is buffer & -device ac97?
PERIPHERY="-usb -device usb-tablet -device virtio-keyboard-pci"
NET="-net nic -net user"
DISPLAY="-vga qxl -display spice-app,gl=on"	# Last param enables clipboard sync
SPICE="-spice unix=on,addr=/tmp/vm_spice.socket,disable-ticketing=on"	 #-device virtserialport,chardev=spicechannel0,name=com.redhat.spice.0 -chardev spicevmc,id=spicechannel0,name=vdagent

cd ~/vm
qemu-system-x86_64 $KVM $HW $AUDIO $PERIPHERY $NET $DISPLAY $SPICE -hda disk.qcow2
# -drive file=parrot.iso,media=cdrom'';
    };

  };
}