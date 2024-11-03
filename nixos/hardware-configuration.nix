{
  config,
  lib,
  modulesPath,
  ...
}:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];
  
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  
  boot = {kernelParams = [ ];
          initrd.availableKernelModules = [
            "nvme"
            "ahci"
            "xhci_pci"
            "usbhid"
            "usb_storage"
            "sd_mod"
          ];
          initrd.kernelModules = [ ];
          kernelModules = [ "kvm-amd" ];
          extraModulePackages = [ ];
         };
  
  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/a505bb53-008f-4f92-8bde-86ca364baf54";
      fsType = "ext4";
    };

    "/home" = {
      device = "/dev/disk/by-uuid/d820d808-12a3-4f89-a591-25299990a6b2";
      fsType = "ext4";
    };

    "/boot/efi" = {
      device = "/dev/disk/by-uuid/1BC1-AFF5";
      fsType = "vfat";
    };

    "/mnt/Data" = {
      device = "/dev/disk/by-uuid/f6bf6cd6-65cb-433c-a1f7-6d10fcdd14e4";
      fsType = "ext4";
    };
  };
}
