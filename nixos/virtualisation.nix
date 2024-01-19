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
    # Source: https://carjorvaz.com/posts/rootless-podman-and-docker-compose-on-nixos/
    containers.enable = true;
    containers.storage.settings = {
      storage = {
        driver = "overlay";
        runroot = "/run/containers/storage";
        graphroot = "/var/lib/containers/storage";
        rootless_storage_path = "$HOME/.local/share/containers/storage";
        options.overlay = {
          mountopt = "nodev,metacopy=on";
          force_mask = "shared"; # TODO profile-sync-daemon wants to access the storage under `.local/share/containers/storage`, but this switch doesn't works...
        };
        # Source: https://github.com/containers/podman/blob/main/vendor/github.com/containers/storage/storage.conf
        options.pull_options = {
          enable_partial_images = "true";
          use_hard_links = "true";
          ostree_repos = "";
        };
      };
    };
    oci-containers.backend = "podman"; # Should be default
    containerd.enable = true; # buildx_buildkit_default container likes to access this
    # level=warning msg="skipping containerd worker, as \"/run/containerd/containerd.sock\" does not exist"
    # level=info msg="found 1 workers, default=\"yauwex2lqranut8gilobu4yyr\""
    # level=warning msg="currently, only the default worker can be used."
    # level=info msg="running server on /run/buildkit/buildkitd.sock"

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
    DOCKER_BUILDKIT = "1"; # TODO docker-compose seems to pull a buildx-container for building, which this sadly doesn't avoids
  };

  environment.systemPackages = with pkgs; [
    podman-compose
    docker-compose
    docker-buildx
    buildkit
  ];
}
