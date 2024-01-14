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

    # Containerization
    # Source: https://carjorvaz.com/posts/rootless-podman-and-docker-compose-on-nixos/
    containers.enable = true;
    containers.storage.settings = {
      storage = {
        driver = "overlay";
        runroot = "/run/containers/storage";
        graphroot = "/var/lib/containers/storage";
        rootless_storage_path = "$HOME/.local/share/containers/storage"; # TODO psd seems to copy this
        options = {
          overlay.mountopt = "nodev,metacopy=on";
          # Source: https://github.com/containers/podman/blob/main/vendor/github.com/containers/storage/storage.conf
          pull_options = "{ enable_partial_images = true, use_hard_links = true, ostree_repos=\"\"}";
        };
      };
    };
    oci-containers.backend = "podman"; # Should be default

    ## Podman
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
    };
  };
  environment.variables = {
    DOCKER_HOST = "unix://$XDG_RUNTIME_DIR/podman/podman.sock";
    DOCKER_BUILDKIT = "1"; # TODO docker-compose seems to pull a buildx-container for building, which this might avoid
  };

  environment.systemPackages = with pkgs; [
    podman-compose
    docker-compose
    docker-buildx
    buildkit
  ];
}
