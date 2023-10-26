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

- Clone this repo anywhere

```bash
# Add Module-Channels for NixOS (can also be used for home-manager standalone, but need different channel urls)
sudo nix-channel --add https://nixos.org/channels/nixos-23.05 nixos
sudo nix-channel --add https://nixos.org/channels/nixos-unstable nixos-unstable
sudo nix-channel --add https://github.com/nix-community/home-manager/archive/release-23.05.tar.gz home-manager
sudo nix-channel --add https://github.com/Mic92/sops-nix/archive/master.tar.gz sops-nix

## Add Module-Channels for home-manager
sudo nix-channel --add https://github.com/pjones/plasma-manager/archive/trunk.tar.gz plasma-manager

# Linking the repo contents into the right places
sudo ln -s /home/jnnk/devel/own/dotfiles.nix/nixos /etc/nixos
ln -s /home/jnnk/devel/own/dotfiles.nix/home-manager /home/jnnk/.config/home-manager
```

## TODO-List

Things I have to do after the installation...

- [ ] Enable the installed GNOME-extensions
- [ ] `ssh-add -v ~/.ssh/<ssh-key-name>`

### Logins

- [ ] Nextcloud, Dropbox
- [ ] Firefox, Thunderbird
- [ ] JetBrains (IDEA, CLion, ...)
- [ ] Whatsapp, Telegram, Signal
- [ ] Discord, Element
- [ ] Teams?
