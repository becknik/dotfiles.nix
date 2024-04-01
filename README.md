# dotfiles.nix

My over-engineered approach of declaratively syncing my desktop setups between all my devices.

## Project Structure

Rough repo structure with significant files:

```shell
$ tree -a -I '\.git|\.vscode' .
.
├── flake.nix
├── darwin
│   ├── configuration.nix
│   └── home.nix
├── disko
│   ├── ext4-encrypted.nix
│   └── ext4-unencrypted.nix
├── home-manager
│   ├── default.nix
│   ├── desktop-env.nix
│   ├── desktop-env
│   │   ├── autostart.nix
│   │   ├── folders-and-files.nix
│   │   ├── plasma.nix
│   │   └── shell.nix
│   ├── devel.nix
│   ├── devel / proglangs.nix
│   ├── media.nix
│   ├── media / mail.nix (not working ._.)
│   ├── packages.nix
│   ├── programs
│   │   ├── git.nix
│   │   ├── neovim.nix
│   │   └── vscodium.nix
│   ├── secrets.nix
│   ├── secrets
│   │   ├── git.yaml
│   │   ├── gpg-personal.asc
│   │   └── keepassxc.key
│   └── .sops.yaml
├── nixos
│   ├── dnix
│   │   ├── default.nix
│   │   └── hardware-configuration.nix
│   ├── lnix / --"--
│   ├── default.nix
│   ├── desktop-env.nix
│   ├── gnome.nix
│   ├── packages.nix
│   ├── systemd.nix
│   └── virtualisation.nix
├── overlays
│   ├── build-fixes.nix
│   ├── build-skips.nix
│   ├── default.nix
│   └── modifications.nix
├── pkgs
│   └── default.nix
└── README.md
```

## Setup

- [Misterio77](https://github.com/Misterio77/nix-starter-configs)-style Flake-based NixOS + [home-manager](https://github.com/nix-community/home-manager) setup
  - Configuration for laptop (`lnix`) & desktop (`dnix`)
  - [`nix-hardware`](https://github.com/NixOS/nixos-hardware) setup for each
  - [nix-darwin](https://github.com/lnl7/nix-darwin) setup for work laptop (`wnix`), which uses a subset of the home-managed part
- Target platform build optimization to Alderlake CPU architecture (on desktop only)
  - Overlays & systemd services to make this a bit more convenient
- Highly customized GNOME Wayland DE with some KDE tools
- Home-manager is used for managing everything apart from system stuff
- home-managed secrets with [sops-nix](https://github.com/Mic92/sops-nix); [age](https://github.com/FiloSottile/age) encrypted

### Further great Projects used

- [nixvim](https://github.com/nix-community/nixvim)
  - [elythh's config](https://github.com/elythh/nixvim) is highly recommendable to get started
- [plasma-manager](https://github.com/pjones/plasma-manager)
- [disko](https://github.com/nix-community/disko): for NixOS partitioning & deployment
- [Flockenzeit](https://github.com/balsoft/Flockenzeit): Date & time parsing and formatting in native Nix. Awesome!
  - Used in conjunction with flake's `inputs.self.sourceInfo.lastModified` for systemd NixOS automatic rebuild logs :^)
- [mac-app-util](https://github.com/hraban/mac-app-util): Automatically creating trampoline symlinks for home-managed Mac software
  - I really hate MacOS, but this lib makes me hate using it with nix-darwin a bit less

### Features

- Over-engineering in it's purest form (heh). Spent days on this config - and there are still ~80 TODOs :|
- Systemd Services:
  - `nixos-upgrade-notify-send-(failure|success).service` - Sends desktop notification when nixos-upgrade unit finished
  - `nixos-upgrade-automatic-shutdown.service` - Shuts down the desktop when nixos-upgrade service finished
  > Disabled by default; Must be started manually
  - `nixos-upgrade.service` writes build logs to `/var/log/nixos-upgrade/`
- `nixos-fetch-and-switch-on-change` - Pulls and executes `nixos-rebuild switch` when this repos local differs from remote
  - TODO Sadly this needs love and isn't working
- `nixos`/`darwin-rebuild` shell alias - see bottom of [shell.nix](./home-manager/desktop-env/shell.nix) file

## Getting Started/ Deployment

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

### Todolist for after Installation

Sometimes its nice to have a good starting point, when one spent hours on bringing a system to run :)
Let's hope this projects break the hours down to minutes (assumed native building is disabled ofc)

- [ ] Enable the installed GNOME-extensions
  - [ ] Setup `gsconnect`
- [ ] Copy the nix-sops secret to the new system
- [ ] (Configure the CPU-scheduler and profile in `cpupower-gui`)

#### Logins

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
