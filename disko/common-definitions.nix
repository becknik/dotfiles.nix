{
  esp = {
    name = "esp";
    priority = 1;
    size = "512M";
    type = "EF00"; # EF02 results in a "grub-something" partition flag
    content = {
      type = "filesystem";
      format = "vfat";
      mountpoint = "/boot";
    };
  };

  nix = size: {
    name = "nix";
    priority = 2;
    inherit size;
    content = {
      type = "filesystem";
      format = "ext4";
      mountpoint = "/nix";
      mountOptions = [ "noatime" ];
    };
  };

  mount-options-ext4-default = [ "lazytime" "commit=60" ];
}
