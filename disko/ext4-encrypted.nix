{ disks ? [ "/dev/nvme0n1" ], ... }:

let
  cd = import ./common-definitions.nix;
in
{
  disko.devices = {
    disk = {
      main = {
        device = builtins.elemAt disks 0;

        content = {
          type = "gpt";

          partitions = {
            esp = cd.esp;
            nix = (cd.nix "96G");

            root = {
              name = "nixos";
              size = "100%";

              content = {
                # https://github.com/nix-community/disko/blob/master/lib/types/luks.nix
                name = "nixos-luks";
                type = "luks";
                settings.allowDiscards = true;
                askPassword = true;

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
  };
}
