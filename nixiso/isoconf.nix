{ config, pkgs, lib, modulesPath,... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix") ];
  #Networking
  networking.networkmanager.wifi.backend = "iwd";
  networking.networkmanager.enable = false;
  networking.hostName = "nixoslive";
  services.resolved.enable = true;
  networking.wireless.iwd.enable = true;
  networking.wireless.iwd.settings = {
   Network = {
    EnableIPv6 = true;
    };
    General = {
    EnableNetworkConfiguration = true;
    };
    Settings = {
    AutoConnect = true;
    };
  };

  networking.useDHCP = false;
  time.timeZone = "Europe/Prague";
  #Networking

  #Desktop shenanigan
  environment.etc."sway/config".source = ./sway/config;
  environment.etc."sway/somescriptname".source = ./sway/status.sh; 
   services.udisks2.enable = false;
   programs.xwayland.enable = true;
   programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    extraPackages = with pkgs; [
    slurp grim wl-clipboard wf-recorder  mc
    alacritty brightnessctl bemenu
    ];
  };
  #Hard Soft shenanigans
  services.getty.autologinUser = "nixos";
  zramSwap.enable = true;
  zramSwap.memoryPercent = 95;
  hardware.opengl.enable = true;
  hardware.opengl.driSupport = true;
  hardware.opengl.driSupport32Bit = true;
  services.power-profiles-daemon.enable = true;
  #Boot shenanigans
  boot.loader = {
   systemd-boot.enable = true;
   efi = {
    canTouchEfiVariables = true;
   };
  };
 #Boot shenanigans

 #Sound
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire.media-session.enable = true;
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
  };

  systemd.services = {
    alsa-store = {
      enable = false;
      restartIfChanged = false;
    };
  };

  hardware.bluetooth.enable = true;
  #Sound

  #User options
  users.users.nixos = {
    isNormalUser = true;
    extraGroups = [ "wheel" "audio" "video" ];
    password = "nixos";

  };
  security.sudo = {
    enable = true;
    wheelNeedsPassword = lib.mkForce false;
  };

  programs.bash.shellAliases = {
   l = "ls -CF";
   dir = "dir --color=auto";
   vdir = "vdir --color=auto";
   grep = "grep --color=auto";
   fgrep = "fgrep --color=auto";
   egrep = "egrep --color=auto";
   la = "ls -a";
   ll = "ls -lh";
   lla = "ls -lha";
   ls = "ls --color=auto";
 };
 #User options

 #Packages
 nixpkgs.config.allowUnfree = true;

 services.locate = {
    enable = true;
    locate = pkgs.mlocate;
    interval = "hourly";
 };
 programs.java.enable = true;
 environment.systemPackages = with pkgs; [
 wget noto-fonts-cjk noto-fonts-extra lm_sensors htop time unrar gnutar noto-fonts-emoji
 acpi usbutils chromium wgetpaste psmisc cryptsetup file git pulseaudio gnome.adwaita-icon-theme
 lsof bind nixos-install-tools
 ];
 #Packages

 #Hardware
  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod" "sdhci_pci" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  system.stateVersion = "21.11";

}
