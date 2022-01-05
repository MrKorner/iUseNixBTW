{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];
  
  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod" "sdhci_pci" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel amdgpu" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/8bd0a08d-25b3-48b7-8965-ab4c32756c1b";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/2636-B7C7";
      fsType = "vfat";
    };

  fileSystems."/home" =
    { device = "/dev/disk/by-uuid/63c0ab39-27a0-44ec-96ca-20c8a5b2b1aa";
      fsType = "ext4";
    };

  fileSystems."/mnt/Data" =
    { device = "/dev/sda1";
      fsType = "ext4";
    };

  powerManagement.cpuFreqGovernor = lib.mkDefault "balanced";
}
