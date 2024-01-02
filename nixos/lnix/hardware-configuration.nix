{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  swapDevices = [
    {
      device = "/swapfile";
      size = 16 * 1024;
      discardPolicy = "both";
    }
  ];


  # Kernel Stuff
  boot = {
    kernelModules = [ "amdgpu" ];
    extraModulePackages = with config.boot.kernelPackages; [ zenpower ];
    initrd = {
      availableKernelModules = [ "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
      kernelModules = [ ];
    };

    kernelParams = [ ]; # "amd_pstate" managed by nixos-hardware
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
  hardware.cpu.amd.updateMicrocode = lib.mkDefault true;


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


  # Power Management
  powerManagement.powertop.enable = true;
  # https://github.com/AdnanHodzic/auto-cpufreq
  services.auto-cpufreq.enable = true;

  hardware.asus.battery.chargeUpto = 85; # @nixos-hardware
}
