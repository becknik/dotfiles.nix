{
  esp = {
    name = "esp";
    priority = 1;
    size = "512M";
    type = "EF02"; # EF00
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
