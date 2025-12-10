{ pkgs, ... }:

{
  users.extraGroups.vboxusers.members = [ "jnnk" ];

  # Libvirtd / QEMU
  programs.virt-manager.enable = true;
  virtualisation = {
    libvirtd = {
      enable = true;

      qemu = {
        swtpm.enable = true; # software tpm emulation
      };
    };

    # VBox
    virtualbox.host.enable = true;

    # Containerization
    docker = {
      enable = true;
      daemon.settings = {
        fixed-cidr-v6 = "fd00::/80";
        ipv6 = true;
      };
      autoPrune = {
        enable = false;
        dates = "monthly";
      };
    };
  };

  environment.systemPackages = with pkgs; [
    docker-compose
  ];
}
