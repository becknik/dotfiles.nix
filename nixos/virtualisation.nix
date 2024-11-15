{ pkgs, ... }:

{
  # Libvirtd / QEMU
  programs.virt-manager.enable = true;
  virtualisation = {
    libvirtd = {
      enable = true;
      qemu = {
        ovmf.enable = true; # something with UEFI boot
        swtpm.enable = true; # software tpm emulation
      };
    };

    # VBox
    /* virtualbox.host = { # TODO virtualbox build is broken
      enable = true;
      enableExtensionPack = true;
    }; */

    # Containerization
    docker = {
      enable = true;
      daemon.settings = {
        fixed-cidr-v6 = "fd00::/80";
        ipv6 = true;
      };
      autoPrune = {
        enable = true;
        dates = "monthly";
      };
    };
  };

  environment.systemPackages = with pkgs; [
    docker-compose
  ];
}
