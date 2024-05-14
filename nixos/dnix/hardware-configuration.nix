{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ]; # Don't know what it does, but the system breaks when removing it...

  swapDevices = [
    {
      device = "/swapfile";
      size = 32 * 1024;
      #randomEncryption.enable = true; # "Don’t try to hibernate when you have at least one swap partition with this option enabled!"
      discardPolicy = "both"; # randomEncryption.allowDiscards defaults to false
      #priority = -1; # always is -2, probably because it's a file (Linux man page claims range -1 to 32767 allowed...)
    }
  ];


  # Kernel Stuff
  boot = {
    kernelModules = [ "kvm-intel" ];
    extraModulePackages = with config.boot.kernelPackages; [ cpupower ];
    initrd = {
      availableKernelModules = [ "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
      kernelModules = [ ];
    };
  };

  services.cpupower-gui.enable = true;

  # CPU
  hardware.cpu.intel.updateMicrocode = lib.mkDefault true;
  #powerManagement.cpuFreqGovernor = lib.mkDefault "performance"; # Managed by cpupower kernel module & gui

  # Hardware Acceleration
  hardware.opengl.extraPackages = with pkgs; [
    intel-compute-runtime
    intel-media-driver
  ];
  ## Graphics
  environment.variables.LIBVA_DRIVER_NAME = "intel"; # Might be redundant

  ## Further
  hardware.bluetooth = {
    enable = false;
    powerOnBoot = false;
  };

  services.hardware.openrgb.enable = true;
  systemd.services.openrgb.enable = false; # disable openrgb starting in server mode on port 6742
}
