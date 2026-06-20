# dotfiles.nix

My over-engineered approach of declaratively syncing my desktop setups between all my devices.

Some nice *bits of knowledge* I came across along the buildup of this flake are ~~documented~~ accumulated [right here](./docs)

## Project Structure

```bash
$ tree -a -I '\.git|\.direnv' . # slightly modified for better context/ overview
.
├───────────────────────────────────────────
├── .devenv
├── flake.nix
├── patches # patches for flake inputs
├── disko
│   ├── ext4-encrypted.nix
│   └── ext4-unencrypted.nix
├── .sops.yaml
├── home-manager
│   ├── default.nix
│   ├── users # home-manager is actually user-based
│   │   ├── nixos.nix
│   │   └── darwin.nix # import subset of files that makes sense for my work laptop
│   ├── secrets # secrets are managed using sops & age stored inside of a yubikey
│   │   └── ...
│   ├── packages.nix
│   ├── desktop-env
│   │   └── ...
│   ├── devel
│   │   └── ...
│   └── media
│       └── ...
├── nixos
│   ├── dnix
│   │   ├── default.nix
│   │   └── hardware-configuration.nix
│   ├── lnix #  same as dnix
│   ├── default.nix
│   ├── desktop-env.nix
│   ├── gnome.nix
│   ├── packages.nix
│   ├── systemd.nix
│   └── virtualisation.nix
├── nixvim # see README there
│   └── ...
├── overlays
│   ├── default.nix
│   ├── modifications.nix
│   ├── modification # package patches
│   │   └── ...
├── darwin
│   ├── default.nix
└── pkgs # custom packages (+ nixvim)
```

## Setup

- [Misterio77](https://github.com/Misterio77/nix-starter-configs)-style Flake-based NixOS + [home-manager](https://github.com/nix-community/home-manager) setup
  - Configuration for laptop (`lnix`) & desktop (`dnix`)
  - [`nix-hardware`](https://github.com/NixOS/nixos-hardware) setup for each
  - [nix-darwin](https://github.com/lnl7/nix-darwin) setup for work laptop (`wnix`), which uses a subset of the home-managed part
  - Overlays & systemd services to make this a bit more convenient
- Highly customized GNOME Wayland DE with some KDE tools
- `home-manager` for managing everything apart from system stuff
- Home-managed secrets with [sops-nix](https://github.com/Mic92/sops-nix) ([age](https://github.com/FiloSottile/age) encrypted)
- [nixvim](https://github.com/nix-community/nixvim) setup with standalone approach to enable `main` branch despite using "stable" `home-manager`
  - To checkout my nixvim setup, don't hesitate to use `nix run .#nixvim <some-file>`
  - Used [elythh's config](https://github.com/elythh/nixvim) as a starting point

### Further great Projects used

- [disko](https://github.com/nix-community/disko): For NixOS partitioning & deployment
- [Flockenzeit](https://github.com/balsoft/Flockenzeit): Date & time parsing and formatting in native Nix. Awesome!
  - Used in conjunction with flake's `inputs.self.sourceInfo.lastModified` for systemd NixOS automatic rebuild logs :^)
- [nix-vscode-extensions](https://github.com/nix-community/nix-vscode-extensions): The few extensions being available in `nixpkgs` (some of which being outdated) replaced by the latest & all available on `open-vsx` & marketplace!

### Features

- Over-engineering in it's purest form (heh). Spent days on this config - and there are still ~80 TODOs :|
- Systemd Services:
  - `nixos-upgrade-notify-send-(failure|success).service` - Sends desktop notification when nixos-upgrade unit finished
  - `nixos-upgrade-automatic-shutdown.service` - Shuts down the desktop when nixos-upgrade service finished
  > Disabled by default; Must be started manually
  - `nixos-upgrade.service` writes build logs to `/var/log/nixos-upgrade/`
- `nixos-fetch-flake-changes.service` - Checks for upstream changes of flake and executes `nixos-rebuild switch` if so
- rebuild shell alias: See bottom of [shell.nix](./home-manager/desktop-env/shell.nix)

## Getting Started

- Enter the `nix repl`

```nix
# aliased as nrepl
nix repl --expr "builtins.getFlake \"$HOME/devel/own/dotfiles.nix\""
```

## Deployment

1. Partition disks with [disko](https://github.com/nix-community/disko):

```shell
sudo nix run github:nix-community/disko \
    --extra-experimental-features "nix-command flakes" -- \
    --mode disko ./disko/ext4-(un)encrypted.nix (--arg disks '[ "/dev/sdX" ]')
# If the command succeeds, the partitions are automatically mounted under /mnt
```

2. `sudo nixos-install --flake </home/nixos/>dotfiles.nix#<host> -j 4 --cores 2`
3. reboot

## Todo List for Post-Installation

Sometimes its nice to have a good starting point, when one spent hours on bringing a system to run :)
Let's hope this projects break the hours down to minutes

- [ ] Copy the nix-sops secret to the new system
- [ ] Enable the installed GNOME-extensions
  - [ ] Setup `gsconnect`
- [ ] (Configure the CPU-scheduler and profile in `cpupower-gui`)
- [ ] Fix `dconf` settings for shortcuts being ignored by home-manager dconf generator (?):
  - [ ] "Open the quick settings menu" => `Disabled` (\[delete\] key)
  - [ ] "Show the overview" => `<Super>s`

### Logins

- [ ] Nextcloud
- [ ] Enter Thunderbird mail account passwords (are mounted, but impossible to automatically pass to Thunderbird)
- [ ] Firefox Account
- [ ] JetBrains (IDEA, CLion, ...)
- [ ] Obsidian
- [ ] Telegram, Signal, Threema, Element
- [ ] planify
- [ ] Anki

### Autostart must be manually Enabled

- [ ] keepassxc
- [ ] Nextcloud
- [ ] telegram-desktop
- [ ] planify
- [x] element-desktop (manually created in `autostart.nix`)
