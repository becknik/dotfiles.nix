# Nice Bits

## NixOS

```nix
# This will additionally add your inputs to the system's legacy channels
# Making legacy nix commands consistent as well, awesome
nix.nixPath = [ "/etc/nix/path" ];
environment.etc = lib.mapAttrs'
  (name: value: {
    name = "nix/path/${name}";
    value.source = value.flake;
  })
  config.nix.registry;
```
