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
│   ├── ~~build-fixes.nix~~                  ├── secrets
│   ├── ~~build-skips.nix~~                  │   ├── git.yaml
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
- ~~Target platform build optimization to alderlake CPU architecture (on desktop only)~~

  > After upgrading this flake to the NixOS 24.05 release on the `dnix` system, I noticed that many packages failed to build due to the `pkgs.fastStdenv` I was using to speed up my system closure's build time - or at least that's what I'm making responsible for it.
  >
  > The package build errors were caused by gcc errors like `-Wincompatible-pointer-types` or `-Wimplicit-function-declaration`.
  > When around 300 of the actual systems packages finally had been built, I had to manually use the "clean", non-optimized package overlays for around 7 dependency packages by adding them to my `overlays/build-fixes.nix` file.
  > This not only was really annoying when running builds asynchronous like I typically do, but also it reminded me of some concerns I had about the CPU-architecture specific optimization in general.
  > The CPU-tailored builds not only take way to long - even tho my build machine features a raptorlake i7 -, but they also waste a lot of energy, emit much heat and also kind of revert the beauty of the NixOS system.
  > I mean in theory, it should be possible to boot my flake from any other machine, or propagate changes from the config into the running system in no time.
  > For instance, I saw myself waiting around one hour for the steam NixOS module to compile, so that I could simply join some friends on a game they were playing.
  > I think this should've gone faster on any other OS, perhaps even on a Gentoo system and is in the end just my own perfectionism and maybe a few percent of performance improvements for some packages making my life harder...
  >
  > Hence due to all these concerns/ issues and the problems with 24.05 & (perhaps) `fastStdenv`, I decided to just let the architecture-optimization be and based my `dnix` system closure back to the default, stable & non-optimized `stdenv` enabling the caching for most packages :^)
  > See [here](https://github.com/becknik/dotfiles.nix/releases/tag/cpu-optimization) for working state of optimized build

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

- [ ] Nextcloud, (Dropbox <- broken?)
- [ ] Enter Thunderbird mail account passwords (are mounted, but impossible to automatically pass to Thunderbird)
- [ ] Firefox Account
- [ ] JetBrains (IDEA, CLion, ...)
- [ ] Obsidian
- [ ] Telegram, Signal, Threema; Element
- [ ] planify
- [ ] Anki
- [ ] cider

### Autostart must be manually Enabled

- [ ] keepassxc
- [ ] telegram-desktop
- [ ] planify
- [x] element-desktop (manually created in `autostart.nix`)
