{ config, ... }:

{
  networking = {
    hostName = "lnix";
    networkmanager.wifi = {
      powersave = true;
      scanRandMacAddress = true;
      macAddress = config.networking.networkmanager.ethernet.macAddress;
    };
  };

  LIBVA_DRIVER_NAME = "radeonsi";

  hardware.acpilight.enable = true; # backlight

  services.fprintd.enable = true;

  boot.extraModulePackages = with config.boot.kernelPackages; [ zenpower ];
  sound.extraConfig = "options snd-hda-intel model=asus-zenboook power_save=1";
# options snd-hda-intel model=alc294-lenovo-mic
# asus-zenbook-ux31a position_fix=*
# options snd-hda-intel model=asus-zenboook power_save=0
# options snd-hda-intel model=asus-zenboook-ux31a power_save=0
# options snd-hda-intel model=asus-laptop power_save=0
# options snd-intel-dspcfg dsp_driver=1
}