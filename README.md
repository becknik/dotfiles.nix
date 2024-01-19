# dotfiles.nix

My way of declaratively syncing the state of my Linux-desktop setups between all my devices.

## Project Structure

```shell
$ tree -a -I '\.git|\.vscode' .
.
├── flake.nix
├── flake.lock
├── disko
│   ├── common-definitions.nix
│   ├── ext4-encrypted.nix
│   └── ext4-unencrypted.nix
├── home-manager
│   ├── default.nix
│   ├── desktop-env.nix
│   ├── desktop-env
│   │   ├── autostart.nix
│   │   ├── dconf.nix
│   │   ├── folders-and-files.nix
│   │   ├── plasma.nix
│   │   ├── shell.nix
│   │   └── xdg-mime.nix
│   ├── devel.nix
│   ├── devel
│   │   └── proglangs.nix
│   ├── media.nix
│   ├── media
│   │   └── mail.nix
│   ├── packages.nix
│   ├── programs
│   │   ├── neovim.nix
│   │   ├── thunderbird.nix
│   │   └── vscodium.nix
│   ├── secrets.nix
│   ├── secrets
│   │   ├── git.yaml
│   │   ├── gpg-personal.asc
│   │   ├── keepassxc.key
│   │   └── mail.yaml
│   └── .sops.yaml
├── nixos
│   ├── browsers.nix
│   ├── default.nix
│   ├── desktop-env.nix
│   ├── dnix
│   │   ├── default.nix
│   │   └── hardware-configuration.nix
│   ├── gnome.nix
│   ├── lnix
│   │   ├── default.nix
│   │   └── hardware-configuration.nix
│   ├── packages.nix
│   ├── systemd.nix
│   └── virtualisation.nix
├── overlays
│   ├── build-fixes.nix
│   └── packages.nix
└── README.md
```

## Setup

- Flake-based NixOS setup
  - Configuration for laptop (`lnix`) & desktop (`dnix`)
  - [`nix-hardware`](https://github.com/NixOS/nixos-hardware) setup for each
- Target platform build optimization to Alderlake CPU architecture (on desktop only)
  - Overlays & systemd services to make this a bit more convenient
- Highly customized GNOME Wayland DE with some KDE tools
- [home-manager](https://github.com/nix-community/home-manager) for managing everything apart from system stuff, DE & browsers
- home-managed [sops-nix](https://github.com/Mic92/sops-nix) with [age](https://github.com/FiloSottile/age) encryption
- [nixvim](https://github.com/nix-community/nixvim)
- [plasma-manager](https://github.com/pjones/plasma-manager)

### Features

- Systemd Services:
  - `nixos-upgrade-notify-send-(failure|success).service` - Sends desktop notification when nixos-upgrade unit finished
  - `nixos-upgrade-automatic-shutdown.service` - Shuts down the desktop when nixos-upgrade service finished
  > Disabled by default; Must be started manually
  - `nixos-upgrade.service` writes logs to `/var/log/nixos-upgrade/`
- `nixos-fetch-and-switch-on-change` - Pulls and executes `nixos-rebuild switch` when this repos local differs from remote
- Shell alias (see [shell.nix](./home-manager/desktop-env/shell.nix) for specifics)
  - `nrbt`, `nrbb` & `nrbs` - `nixos-rebuild test/boot/switch` for currently activated flake profile
  - `ngc*` - Some common options on `nix-collect-garbage`

## Getting Started

1. Partition disks with [disko](https://github.com/nix-community/disko):

```shell
sudo nix run github:nix-community/disko \
    --extra-experimental-features "nix-command flakes" -- \
    --mode disko ./disko/ext4-(un)encrypted.nix (--arg disks '[ "/dev/sdX" ]')
# If the command succeeds, the partitions are automatically mounted under /mnt
```

2. `sudo nixos-generate-config --root /mnt`, then merge/ configure `hardware-configuration.nix`:
  - `cat /mnt/etc/nixos/hardware-configuration.nix >> ./nixos/<profile>/hardware-configuration.nix`
  - Adjust it to your needs
3. Replace in `default.nix` of `<profile>` the `kernelPackages = pkgs.linux_xanmod_latest_patched_<profile>;` line with `pkgs.linux_xanmod_latest` to avoid compilation;
4. `cd /mnt && sudo nixos-install --flake </home/nixos/>dotfiles.nix#(d|l)nix`
5. `sudo cp /home/nixos/dotfiles.nix /mnt/home/<username>/devel/own`

## TODOs After Installation

- [ ] Enable the installed GNOME-extensions
  - [ ] Setup `gsconnect`
- [ ] Copy the nix-sops secret to the new system
- [ ] (Configure the CPU-scheduler and profile in `cpupower-gui`)

### Logins

- [ ] Thunderbird with Mail Accounts (because home-managed ones won't work :( )
- [ ] Firefox
- [ ] Nextcloud, (Dropbox <- broken?)
- [ ] JetBrains (IDEA, CLion, ...)
- [ ] Whatsapp, Telegram, Signal
- [ ] Discord, Element
- [ ] Obsidian
- [ ] Anki
- [ ] (Teams)

### Manually Enable Autostart

- [ ] keepassxc
- [ ] telegram-desktop
- [ ] planify
- [x] element-desktop (manually created in `autostart.nix`)
- [x] whatsapp-for-linux ( " )
- [ ] (teams-for-linux)
