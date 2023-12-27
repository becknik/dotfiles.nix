# dotfiles.nix

## Project Structure

```shell
$ tree # main branch
.
├── flake.nix
├── flake.lock
├── disko
│   ├── ext4-encrypted.nix
│   └── ext4-unencrypted.nix
├── home-manager
│   ├── .sops.yaml
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
│   ├── home.nix
│   ├── media.nix
│   ├── media
│   │   └── mail.nix
│   ├── packages.nix
│   ├── programs
│   │   ├── librewolf.nix
│   │   ├── neovim.nix
│   │   ├── thunderbird.nix
│   │   └── vscodium.nix
│   ├── secrets.nix
│   └── secrets
│       ├── git.yaml
│       ├── gpg-personal.asc
│       ├── keepassxc.key
│       └── mail.yaml
├── nixos
│   ├── configuration.nix
│   ├── desktop-env.nix
│   ├── gnome.nix
│   ├── hardware-configuration.nix
│   ├── nix-setup.nix
│   ├── packages.nix
│   ├── packages
│   │   └── browsers.nix
│   ├── systemd.nix
│   └── virtualisation.nix
├── overlays
│   ├── build-fixes.nix
│   └── packages.nix
└── README.md
```

## Setup

- Flake-based NixOS 23.11 setup
- Highly customized GNOME Wayland DE with some KDE tools
- Target platform build optimization to Alderlake CPU architecture
  - Some Overlays to make this a bit more convenient
- [home-manager](https://github.com/nix-community/home-manager) for managing everything apart from systemd config, browsers & DE
- home-managed [sops-nix](https://github.com/Mic92/sops-nix) with [age](https://github.com/FiloSottile/age) encryption
- [nixvim](https://github.com/nix-community/nixvim)
- [plasma-manager](https://github.com/pjones/plasma-manager)

### Features

- Systemd Services:
  - `nixos-upgrade-notify-send-{failure|success}.service` - Sends desktop notification when automatic nixos-upgrade finished
  - `nixos-upgrade-automatic-shutdown.service` - Shuts down the desktop when nixos-upgrade service finished
  > Disabled by default; Must be started manually
- Shell alias (see [shell.nix](./home-manager/desktop-env/shell.nix) for specifics)
  - `nrbt` & `nrbs` - `nixos-rebuild test/switch` with this flake & the `dnix` host
  - `ngc*` - Some common options on `nix-collect-garbage`

## Getting Started

> After my switch to the flake-setup, I altered this instruction significantly.
> It's not tested on my machine so far, so it might (and probably will) lack some edge case steps.
> My guess is, that something with my ssh git setup goes bananas...

1. Clone this repo & `cd` into it
2. Disk Partitioning with [disko](https://github.com/nix-community/disko):

```shell
sudo nix run github:nix-community/disko \
    --extra-experimental-features nix-command --extra-experimental-features flakes -- \
    --mode disko ./disko/ext4-unencrypted.nix --arg disks '[ "/dev/sdX" ]'
# If the command succeeds, the partitions are mounted automatically under /mnt
```

3. `sudo nixos-generate-config --root /mnt` and include the generated config in your nix configuration
   - This can either be archieved by 1) replacing the `configuration.nix`s `import ./hardware/desktop.nix` with your `hardware-configuration.nix`, or...
   - By 2) altering this repos `/nixos/hardware/desktop.nix` to your liking (by substituting the UUIDs, cpu-modules, etc.) and then `sudo rm /mnt/etc/nixos/hardware-configuration.nix`ing
4. Comment out in `configuration.nix` the `kernelPackages = pkgs.linux_xanmod_latest_custom;` line and use a kernel package from the nix repo database instead to save some installation time
5. `cd /mnt && sudo nixos-install --flake <repo-root>/nixos#dnix`
6. `sudo cp dotfiles.nix /mnt/home/jnnk` to spare re-cloning this repo
7. `sudo nixos-rebuild --flake ~/dotfiles.nix/nixos#dnix switch`
8. Comment in the Linux kernel overlay from step again, turn off GNOME's "Automatic Suspend" and `sudo nixos-rebuild --flake ~/dotfiles.nix/nixos#dnix boot`

## After Installation TODO-List

- [ ] Enable the installed GNOME-extensions
  - [ ] Setup `gsconnect`
- [ ] `ssh-add -v ~/.ssh/<ssh-key-name>`
- [ ] Configure the CPU-scheduler and profile in `cpupower-gui`
- [ ] Delete the former capitalized xdg-user-dirs: `rm -fr Templates Videos Public Desktop Documents Downloads Pictures Music tmp` (TODO why is there a `tmp/cache-\$USER/oh-my-zsh` dir?!)
- [ ] Create new nix-sops secrets due to accidental removal of the old primary key...

### Logins

- [ ] Thunderbird with Mail Accounts :(
- [ ] Firefox
- [ ] Nextcloud, Dropbox
- [ ] JetBrains (IDEA, CLion, ...)
- [ ] Whatsapp, Telegram, Signal
- [ ] Discord, Element
- [ ] Obsidian
- [ ] Anki
- [ ] Teams?

### Further

- [ ] Manually enable autostart for:
  - [ ] keepassxc
  - [ ] telegram-desktop
  - [ ] planify
  - [x] element-desktop (manually created in `folders-and-files.nix`)
  - [x] whatsapp-for-linux (")
  - [ ] teams-for-linux
