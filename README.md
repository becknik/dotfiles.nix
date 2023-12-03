# dotfiles.nix

## Project Structure

```shell
$ tree # main branch
/home/jnnk/devel/own/dotfiles.nix
├── disko
│   ├── ext4-encrypted.nix
│   └── ext4-unencrypted.nix
├── home-manager
│   ├── desktop-env
│   │   ├── autostart.nix
│   │   ├── dconf.nix
│   │   ├── folders-and-files.nix
│   │   ├── plasma.nix
│   │   ├── secrets
│   │   │   ├── git.yaml
│   │   │   ├── gpg.yaml
│   │   │   ├── keepassxc.yaml
│   │   │   └── mail.yaml
│   │   ├── secrets.nix
│   │   ├── xdg-mime.nix
│   │   └── zsh.nix
│   ├── desktop-env.nix
│   ├── devel
│   │   ├── ides.nix
│   │   └── proglangs.nix
│   ├── devel.nix
│   ├── home.nix
│   ├── media
│   │   └── mail.nix
│   ├── media.nix
│   ├── packages.nix
│   ├── programs
│   │   ├── librewolf.nix
│   │   ├── neovim.nix
│   │   └── vscodium.nix
│   └── virtualisation.nix
├── nixos
│   ├── configuration.nix
│   ├── desktop-env.nix
│   ├── gnome.nix
│   ├── hardware
│   │   ├── desktop.nix
│   │   └── laptop.nix
│   ├── nix-setup.nix
│   ├── packages
│   │   └── linux-xanmod.nix
│   ├── packages.nix
│   └── virtualisation.nix
└── README.md
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

```shell
sudo nix run github:nix-community/disko \
    --extra-experimental-features nix-command --extra-experimental-features flakes -- \
    --mode disko ./disko/ext4-unencrypted.nix --arg disks '[ "/dev/sdX" ]'
# If the command succeeds, the partitions are mounted automatically under /mnt
```

4. `sudo nixos-generate-config --root /mnt` and include the generated config in your nix configuration
   - This can either be archieved by 1) replacing the `configuration.nix`s `import ./hardware/desktop.nix` with your `hardware-configuration.nix`, or...
   - By 2) altering this repos `/nixos/hardware/desktop.nix` to your liking (by substituting the UUIDs, cpu-modules, etc.) and then `sudo rm /mnt/etc/nixos/hardware-configuration.nix`ing
5. Comment out in `configuration.nix` the `users.jnnk = import /home/jnnk/.config/home-manager/home.nix;` line
   - The home-manager part of the setup is to be done after successfully booting into the system
6. `sudo cp -fr ./nixos/* /mnt/etc/nixos`
7. Comment out in `configuration.nix` the `kernelPackages = pkgs.linux_xanmod_latest_custom;` line and use a kernel package from the nix repo database to avoid compilation of the kernel
8. `cd /mnt && sudo nixos-install`
9. `sudo cp dotfiles.nix /mnt/home/jnnk`
10. Reboot into the system, then...
    - Add the channels from step 2 (again)
    - `mkdir $HOME/.config/home-manager && cp -r $HOME/dotfiles.nix/home-manager/* $HOME/.config/home-manager`
11. Comment in the `import` from step 7 and run `sudo nixos-install` which is supposed to fail
    - It will however create the `$HOME/devel/foreign` directory which is necessary for the next step
    - I'm justbeing layz right here
12. `git clone https://github.com/caiogondim/bullet-train.zsh $HOME/devel/foreign/bullet-train.zsh` to make the symlink specified in
13. Toggle off the GNOME "Automatic Suspend" and `sudo nixos-rebuild boot`

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

- [ ] Enable autostart manually for:
  - [ ] keepassxc
  - [ ] telegram-desktop
  - [ ] planify
  - [x] element-desktop (manually created in `folders-and-files.nix`)
  - [x] whatsapp-for-linux (")
  - [ ] teams-for-linux
