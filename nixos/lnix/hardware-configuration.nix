{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  # TODO systemd-boot seems to not correctly apply this, standard password containing umlauts fails in systemd-boot only
  # However, password containing '@' is correctly mapped to german keyboard...
  console.keyMap = "de"; # Using the german keyboard layout only for the luks password prompt

  swapDevices = [
    {
      device = "/swapfile";
      size = 24 * 1024;
      discardPolicy = "both";
    }
  ];


  # Kernel Stuff
  boot = {
    kernelModules = [ "kvm-amd" "amdgpu" ];
    extraModulePackages = with config.boot.kernelPackages; [ zenpower ];
    initrd = {
      availableKernelModules = [ "nvme" "xhci_pci" "usbhid" "usb_storage" "sd_mod" "sdhci_pci" ];
      kernelModules = [ ];
    };

    kernelParams = [ "usbcore.autosuspend=-1" ]; # "amd_pstate" managed by nixos-hardware
    # sources:
    # https://discourse.nixos.org/t/external-mouse-and-keyboard-sleep-when-they-stay-untouched-for-a-few-seconds/14900/10
  };


  # Hardware Acceleration
  # Source: https://nixos.wiki/wiki/AMD_GPU
  hardware.opengl.extraPackages = with pkgs; [
    amdvlk
    rocmPackages.clr.icd
  ];
  hardware.opengl.driSupport = true; # This is already enabled by default
  services.xserver.videoDrivers = [ "amdgpu" ];

  environment.variables.LIBVA_DRIVER_NAME = "radeonsi"; # Might be redundant


  # CPU
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;


  # Further Hardware Settings
  hardware.bluetooth.enable = true;
  hardware.acpilight.enable = true; # backlight
  services.fprintd.enable = true;
  sound.extraConfig = "options snd-hda-intel model=asus-zenboook power_save=1";

  # options snd-hda-intel model=alc294-lenovo-mic
  # asus-zenbook-ux31a position_fix=*
  # options snd-hda-intel model=asus-zenboook power_save=0
  # options snd-hda-intel model=asus-zenboook-ux31a power_save=0
  # options snd-hda-intel model=asus-laptop power_save=0
  # options snd-intel-dspcfg dsp_driver=1

  hardware.asus.battery.chargeUpto = 85; # @nixos-hardware, doesn't work

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp4s0f4u1u4.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp1s0.useDHCP = lib.mkDefault true;
}
