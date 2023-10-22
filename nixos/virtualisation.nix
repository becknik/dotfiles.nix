{ ... }:

{
  # libvirtd / qemu
  virtualisation = {
    libvirtd = {
      enable = true;
      qemu = {
        ovmf.enable = true; # something with UEFI boot
	      swtpm.enable = true; # software tpm emulation
      };
    };

    # VBox
    virtualbox.host = {
      enable = true;
      enableExtensionPack = true; # this causes recompilations - when?
    };

    # Podman
    podman = {
      enable = true;
      dockerCompat = true; # docker alias for podman
      dockerSocket.enable = true;
      autoPrune.enable = true;
      # Required for containers under podman-compose to be able to talk to each other.
      defaultNetwork.settings = {
        dns_enabled = true;
      };
    };

    # Docker (rootless) (now replaced by podman)
    /*docker = {
      autoPrune.enable = true; # performes weekly prune --all by default
      #storageDriver = "btrfs";
      rootless = {
        enable = true;
        setSocketVariable = true;
      };
    };*/
  };
}