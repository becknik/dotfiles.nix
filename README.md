# dotfiles.nix

## Getting Started

```bash
# All channels used in this configuration

# Module-Channels for NixOS
sudo nix-channel --add https://nixos.org/channels/nixos-23.05 nixos
sudo nix-channel --add https://nixos.org/channels/nixos-unstable nixos-unstable
sudo nix-channel --add https://github.com/Mic92/sops-nix/archive/master.tar.gz sops-nix
sudo nix-channel --add https://github.com/nix-community/home-manager/archive/release-23.05.tar.gz home-manager

## Module-Channels for home-manager
sudo nix-channel --add https://github.com/pjones/plasma-manager/archive/trunk.tar.gz plasma-manager

# Linking the repo contents into the right places
sudo ln -s /home/jnnk/devel/own/dotfiles.nix/nixos /etc/nixos
ln -s /home/jnnk/devel/own/dotfiles.nix/home-manager /home/jnnk/.config/home-manager
```

## References

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
