{ disks ? [ "/dev/vda" ], ... }: {
  disko.devices = {
    disk.main = {
      type = "disk";
      device = builtins.elemAt disks 0;
      content = {
        type = "gpt";
        partitions = {
          ESP = {
            priority = 1;
            name = "esp";
            size = "512M";
            type = "EF00"; # Might set the gpt EFI, BOOT flags?
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
            };
          };
          nix = {
            name = "nix";
            size = "96G";
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/nix";
              mountOptions = [ "noatime" ];
            };
          };
          root = {
            name = "nixos";
            size = "100%";
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/";
              mountOptions = [
                "lazytime"
                "commit=60"
              ];
            };
          };
        };
      };
    };
  };
}

# Static information about the filesystems.
# See fstab(5) for details.

# <file system> <dir> <type> <options> <dump> <pass>
# EFI - /dev/nvme0n1p1
#UUID=F723-D645		/esp	vfat	rw,relatime,fmask=0022,dmask=0022,codepage=437,iocharset=ascii,shortname=mixed,utf8,errors=remount-ro 0 2
#/esp/EFI/arch		/boot	none	defaults,bind 0 2

## ROOT /dev/nvme0n1p5 - Remove discard=async,autodefrag,ssd features for swap file
#UUID=0a41114d-467d-4bc2-a06f-389fb4fc0c7b	/	btrfs	rw,lazytime,compress=none,space_cache=v2,discard=async,autodefrag,ssd 0 1
#/dev/mapper/home	/home	btrfs	rw,lazytime,compress=zstd:3,space_cache=v2,commit=300,discard=async,autodefrag,ssd 0 2

## SWAP
#UUID=8bd5c5a8-80b7-48c2-8d96-44f80b20dfec	none	swap	defaults 0 0
#UUID=0a41114d-467d-4bc2-a06f-389fb4fc0c7b	/swap	btrfs	subvol=swap 0 0
#/swap/swapfile	none	swap	defaults 0 0

## BTRFS subvolumes
#UUID=0a41114d-467d-4bc2-a06f-389fb4fc0c7b	/home/jnnk/.JetBrains	btrfs	subvol=.JetBrains,nodatacow 0 0

# Due to modified Linux kernel compilation
#tmpfs	/tmp					tmpfs	defaults,size=32G 0 0
#tmpfs	/home/jnnk/.cache			tmpfs	defaults,noexec,nodev,nosuid,gid=1000,uid=1000,mode=0700 0 0
#tmpfs	/home/jnnk/.cache/paru			tmpfs	defaults,exec,nodev,nosuid,gid=1000,uid=1000,mode=1700 0 0
#tmpfs	/home/jnnk/.cache/JetBrains		tmpfs	defaults,exec,nodev,nosuid,gid=1000,uid=1000,mode=1700 0 0
#tmpfs	/home/jnnk/.cache/bazel			tmpfs	defaults,exec,nodev,nosuid,gid=1000,uid=1000,mode=1700 0 0
#tmpfs	/home/jnnk/.cache/electron-builder	tmpfs	defaults,exec,nodev,nosuid,gid=1000,uid=1000,mode=1700 0 0
# Seens to be important for signal-beta to build
#tmpfs	/home/jnnk/.cache/yarn			tmpfs	defaults,exec,nodev,nosuid,gid=1000,uid=1000,mode=1700 0 0
#tmpfs	/home/jnnk/.cache/Google		tmpfs	defaults,exec,nodev,nosuid,gid=1000,uid=1000,mode=1700 0 0
