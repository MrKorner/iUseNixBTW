# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

    boot.kernelParams = [ 
    "intel_iommu=on"
    "vfio-pci.ids=1002:699f"
  ];
  hardware.bluetooth.enable = true;
  boot.initrd.availableKernelModules = [ "xhci_pci" "nvme" "usb_storage" "sd_mod" "sdhci_pci" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" 
	"vfio_pci"
    	"vfio"
    	"vfio_iommu_type1" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/a518fdd6-1a96-4f56-b022-695e5559713c";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/02B4-4745";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };
  fileSystems."/home/chonktop/.cache" =
    { device = "none";
      fsType = "tmpfs";  # Can be stored on normal drive or on tmpfs as well
      options = [ "size=5G" "mode=777" ]; 
    };
  networking.useDHCP = lib.mkDefault true;
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = true ;	
  hardware.enableRedistributableFirmware = true;
}
