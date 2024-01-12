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
    /*virtualbox.host = {
      enable = true;
      enableExtensionPack = true; # this causes recompilations - when?
    };*/

    # Podman
    podman = {
      enable = true;
      dockerCompat = true; # docker alias for podman
      dockerSocket.enable = true;
      autoPrune = {
        enable = true;
        dates = "monthly";
      };
      # Required for containers under podman-compose to be able to talk to each other.
      defaultNetwork.settings = {
        dns_enabled = true;
      };
      #extraPackages = with pkgs; [ podman-compose ];
    };
  };
  environment.systemPackages = with pkgs; [ podman-compose ];
}
