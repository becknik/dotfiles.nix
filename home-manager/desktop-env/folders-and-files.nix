{ ... }:

{
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
      text = '''';
    };

    # Files

    "ghci" = {
      target = ".ghci";
      # Source: https://stackoverflow.com/a/53109980
      text = ''
        :set prompt "\ESC[0;34m\STX%s\n\ESC[1;31m\STXλ> \ESC[m\STX"
      '';
    };

    "cargo-config" = {
      target = ".cargo/config";
      text = ''
        [target.x86_64-unknown-linux-gnu]
        rustflags = ["-C", "target-cpu=native"]
      '';
    };

    "keepassxc-config" = {
      target = ".config/keepassxc/keepassxc.ini";
      text = ''
        [General]
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
        MovableToolbar=false
        ShowExpiredEntriesOnDatabaseUnlock=false
        ShowTrayIcon=true
        TrayIconAppearance=colorful

        [PasswordGenerator]
        AdditionalChars=
        AdvancedMode=true
        Braces=true
        Dashes=true
        EASCII=false
        ExcludedChars=
        Length=64
        Logograms=true
        Math=true
        Punctuation=true
        Quotes=true
        SpecialChars=true

        [Security]
        EnableCopyOnDoubleClick=true
        IconDownloadFallback=true
        LockDatabaseIdle=true
        LockDatabaseMinimize=true
      '';
    };

    ## VM Script
    "vm-executer-script" = {
      target = "vm/run.sh";
      text = ''
        #!/bin/bash

        KVM="-enable-kvm -machine q35 -device intel-iommu"	# virtio-serial-pc
        HW="-m 4096 -smp 4 -cpu host"
        AUDIO="-audiodev alsa,id=alsa,driver=alsa,out.buffer-length=500000,out.period-length=726"	# the heck is buffer & -device ac97?
        PERIPHERY="-usb -device usb-tablet -device virtio-keyboard-pci"
        NET="-net nic -net user"
        DISPLAY="-vga qxl -display spice-app,gl=on"	# Last param enables clipboard sync
        SPICE="-spice unix=on,addr=/tmp/vm_spice.socket,disable-ticketing=on"	 #-device virtserialport,chardev=spicechannel0,name=com.redhat.spice.0 -chardev spicevmc,id=spicechannel0,name=vdagent

        cd ~/vm
        qemu-system-x86_64 $KVM $HW $AUDIO $PERIPHERY $NET $DISPLAY $SPICE -hda disk.qcow2
        # -drive file=parrot.iso,media=cdrom
      '';
    };

  };
}
