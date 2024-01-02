{ disks ? [ "/dev/sda" ], ... }:

let
  cd = import ./common-definitions.nix;
in
{
  disko.devices = {
    disk = {
      main = {
        device = builtins.elemAt disks 0;

        content = {
          # TODO Whats the difference between `table` and `gpt` type
          # https://github.com/nix-community/disko/blob/master/lib/types/table.nix
          type = "gpt";

          partitions = {
            esp = cd.esp;
            nix = (cd.nix "192G");

            root = {
              name = "nixos";
              size = "100%";

              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/";
                mountOptions = cd.mount-options-ext4-default;
              };
            };
          };
        };
      };
    };
  };
}
