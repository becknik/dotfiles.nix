# dotfiles.nix

## Project Structure

```bash
$ tree
.
├── nixos
│   ├── configuration.nix
│   ├── desktop-env.nix
│   ├── gnome.nix
│   ├── hardware
│   │   ├── desktop.nix
│   │   └── laptop.nix
│   ├── nix-setup.nix
│   ├── packages.nix
│   ├── packages
│   │   └── linux-xanmod.nix
│   └── virtualisation.nix
├── home-manager
│   ├── desktop-env.nix
│   ├── desktop-env
│   │   ├── autostart.nix
│   │   ├── dconf.nix
│   │   ├── folders-and-files.nix
│   │   ├── plasma.nix
│   │   ├── secrets.nix
│   │   ├── secrets
│   │   │   ├── git.yaml
│   │   │   ├── gpg.yaml
│   │   │   └── keepassxc.yaml
│   │   ├── xdg-mime.nix
│   │   └── zsh.nix
│   ├── devel.nix
│   ├── devel
│   │   ├── ides.nix
│   │   └── proglangs.nix
│   ├── home.nix
│   ├── media.nix
│   ├── packages.nix
│   ├── programs
│   │   ├── librewolf.nix
│   │   ├── neovim.nix
│   │   └── vscodium.nix
│   └── virtualisation.nix
├── README.md
└── disko
    ├── ext4-encrypted.nix
    └── ext4-unencrypted.nix
```

## Setup

- Highly customized GNOME with some KDE tooling
- Neovim & VSCode
- ...

## Utilized Modules

- [home-manager](https://github.com/nix-community/home-manager)
- [sops-nix](https://github.com/Mic92/sops-nix) & [age](https://github.com/FiloSottile/age)
- [nixvim](https://github.com/nix-community/nixvim)
- [plasma-manager](https://github.com/pjones/plasma-manager)

## Getting Started

1. Clone this repo & `cd` into it
2. Add the channels needed. Whether sudo or not should be clear if you want to use standalone home-manager (not tested so far) or NixOS

```bash
# Add Module-Channels for NixOS (can also be used for home-manager standalone, but need different channel urls)
sudo nix-channel --add https://nixos.org/channels/nixos-23.05 nixos
sudo nix-channel --add https://nixos.org/channels/nixos-unstable nixos-unstable
sudo nix-channel --add https://github.com/nix-community/home-manager/archive/release-23.05.tar.gz home-manager
sudo nix-channel --add https://github.com/Mic92/sops-nix/archive/master.tar.gz sops-nix
## Add Module-Channels for home-manager
sudo nix-channel --add https://github.com/pjones/plasma-manager/archive/trunk.tar.gz plasma-manager
sudo nix-channel --update
```

### From NixOS Installer

3. Disk Partitioning with Disko

```bash
sudo nix run github:nix-community/disko \
    --extra-experimental-feature nix-command --extra-experimental-feature flakes -- \\
    --mode disko ./disko/ext4-unencrypted.nix --arg disks '[ "/dev/sdb" ]'
# If the command succeeds, the partitions are mounted automatically under /mnt
```

4. `sudo nixos-generate-config --root /mnt`
5. Replace the UUIDs (etc?) from this repos `./nixos/harware/desktop.nix` with the settings from `/mnt/etc/nixos/hardware-configuration.nix`
6. Comment out the home-manager user-config `import` in this repos `configuration.nix` (the home-manager part is to be done after successfully booting into the system)
7. `mv -f` the `./nixos/*` to `/mnt/etc/nixos`. You may delete the hardware-configuration.nix if you're sure you have all the important settings in this repo `./nixos/hardware/*.nix`-file
8. `cd /mnt && sudo nixos-install` (you might avoid the impure compilation of the kernel in `./nixos/packages/linux-xanmod.nix`)
9. Then reboot into the system & comment in the `import` from step 6
10. `git clone https://github.com/caiogondim/bullet-train.zsh $HOME/devel/foreign/bullet-train.zsh` to make the symlink specified in

### General

- Linking the repo contents into the right places to have the whole configuration editable from this repos directory

```bash
sudo ln -sr ./nixos /etc/nixos # You might want to delete the contents from /etc/nixos first: `sudo rm -rf /etc/nixos`
ln -sr ./home-manager ~/.config # You might have to create this folders first
sudo nixos-rebuild switch
```

## TODO-List

Things I have to do after the installation...

- [ ] Enable the installed GNOME-extensions
- [ ] `ssh-add -v ~/.ssh/<ssh-key-name>`
- [ ] Configure the CPU-scheduler in `cpupower-gui`

### Logins

- [ ] Thunderbird Mail Accounts :(
- [ ] Firefox
- [ ] Nextcloud, Dropbox
- [ ] JetBrains (IDEA, CLion, ...)
- [ ] Whatsapp, Telegram, Signal
- [ ] Discord, Element
- [ ] Teams?
