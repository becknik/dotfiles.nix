# dotfiles.nix

My over-engineered approach of declaratively syncing my desktop setups between all my devices.

Some nice *bits of knowledge* I came across along the buildup of this flake are ~~documented~~ accumulated [right here](./BITS.md)

## Project Structure

```bash
$ tree -a -I '\.git|\.vscode|\.direnv' . # slightly modified for better context/ overview
.
├─────────────────────────────────────────── home-manager
├── flake.nix                                ├── default.nix
├── flake.lock                               ├── desktop-env.nix
├── darwin                                   ├── desktop-env
│   ├── default.nix                          │   ├── autostart.nix
├── .devenv                                  │   ├── dconf.nix
├── disko                                    │   ├── folders-and-files.nix
│   ├── ext4-encrypted.nix                   │   ├── files
│   └── ext4-unencrypted.nix                 │   │   ├── plasma ── ...
├── nixos                                    │   │   ├── .zshrc.initExtra.zsh
│   ├── dnix                                 │   │   └── ...
│   │   ├── default.nix                      │   ├── plasma.nix
│   │   └── hardware-configuration.nix       │   ├── shell.nix
│   ├── lnix ── -- same as dnix --           │   └── xdg-mime.nix
│   ├── default.nix                          ├── devel.nix
│   ├── desktop-env.nix                      ├── devel ── proglangs.nix
│   ├── gnome.nix                            ├── media.nix
│   ├── packages.nix                         ├── media ── mail.nix (not working ._.)
│   ├── systemd.nix                          ├── packages.nix
│   └── virtualisation.nix                   ├── programs
├── nixvim                                   │   ├── git.nix
│   ├── default.nix                          │   ├── thunderbird.nix
│   └── ...                                  │   └── vscodium.nix
├── overlays                                 ├── secrets.nix
│   ├── build-fixes.nix                      ├── secrets
│   ├── build-skips.nix                      │   ├── git.yaml
│   ├── default.nix                          │   ├── gpg-personal.asc
│   ├── modifications.nix                    │   ├── keepassxc.key
│   ├── modification ── ...                  │   └── mail.yaml
│   └── modifications-pref.nix               ├── .sops.yaml
├── pkgs                                     └── users
│   └── default.nix                              ├── darwin.nix
└── README.md                                    └── nixos.nix
```

## Setup

- [Misterio77](https://github.com/Misterio77/nix-starter-configs)-style Flake-based NixOS + [home-manager](https://github.com/nix-community/home-manager) setup
  - Configuration for laptop (`lnix`) & desktop (`dnix`)
  - [`nix-hardware`](https://github.com/NixOS/nixos-hardware) setup for each
  - [nix-darwin](https://github.com/lnl7/nix-darwin) setup for work laptop (`wnix`), which uses a subset of the home-managed part
- Target platform build optimization to Alderlake CPU architecture (on desktop only)
  - Overlays & systemd services to make this a bit more convenient
- Highly customized GNOME Wayland DE with some KDE tools
- `home-manager` is used for managing everything apart from system stuff
- Home-managed secrets with [sops-nix](https://github.com/Mic92/sops-nix) ([age](https://github.com/FiloSottile/age) encrypted)
- [nixvim](https://github.com/nix-community/nixvim) setup with standalone approach to enable `main` branch despite using "stable" `home-manager`
  - To checkout my nixvim setup, don't hesitate to use `nix run .#nixvim <some-file>`
  - Used [elythh's config](https://github.com/elythh/nixvim) as a starting point

### Further great Projects used

- [disko](https://github.com/nix-community/disko): For NixOS partitioning & deployment
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
- `nixos-fetch-flake-changes.service` - Checks for upstream changes of flake and executes `nixos-rebuild switch` if so
- rebuild shell alias: See bottom of [shell.nix](./home-manager/desktop-env/shell.nix)

## Getting Started/ Deployment

1. Partition disks with [disko](https://github.com/nix-community/disko):

```shell
sudo nix run github:nix-community/disko \
    --extra-experimental-features "nix-command flakes" -- \
    --mode disko ./disko/ext4-(un)encrypted.nix (--arg disks '[ "/dev/sdX" ]')
# If the command succeeds, the partitions are automatically mounted under /mnt
```

2. `sudo nixos-install --flake </home/nixos/>dotfiles.nix#<host>`
3. `sudo cp /home/nixos/dotfiles.nix /mnt/home/<username>/devel/own`

## Todo List for Post-Installation

Sometimes its nice to have a good starting point, when one spent hours on bringing a system to run :)
Let's hope this projects break the hours down to minutes (assumed native building is disabled ofc)

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

### Autostart must be manually Enable

- [ ] keepassxc
- [ ] telegram-desktop
- [ ] planify
- [x] element-desktop (manually created in `autostart.nix`)
- [x] whatsapp-for-linux ( " )
