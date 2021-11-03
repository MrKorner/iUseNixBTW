{ config, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix];

  #Networking
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;
  networking.useDHCP = false;
  networking.interfaces.enp3s0.useDHCP = true;
  networking.interfaces.wlp5s0.useDHCP = true;
  networking.wireless.iwd.enable = true;
  networking.networkmanager.wifi.backend = "iwd";
  time.timeZone = "Europe/Prague";
  #Networking

  #Desktop shenanigans
  services.xserver.enable = true;
  services.xserver.desktopManager.pantheon.enable = true;
  programs.pantheon-tweaks.enable = true;
  services.thermald.enable = true;
  services.printing.enable = false;
  services.irqbalance.enable = true;  
  
  #Hardware shenanigans
  services.xserver.videoDrivers = [ "modesetting" "amdgpu" ];
  zramSwap.enable = true;
  zramSwap.memoryPercent = 75;
  security.rtkit.enable = true;
  hardware.opengl.enable = true;
  hardware.opengl.extraPackages = with pkgs; [ vaapiIntel amdvlk intel-compute-runtime rocm-opencl-icd ];
  hardware.opengl.driSupport = true;

  #Desktop Integrations
  services.flatpak.enable = true;
    xdg = {
    portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
      ];
      gtkUsePortal = true;
    };
  };
  #Desktop Integrations

  #Boot shenanigans
    boot.loader = {
    systemd-boot.enable = false;
    efi = {
      canTouchEfiVariables = false;
    };
    grub = {
      efiSupport = true;
      efiInstallAsRemovable = true;
      device = "nodev";
    };
  };
 #Boot shenanigans

 #Service config
    systemd.services = {
    NetworkManager-wait-online = {
      enable = false;
      restartIfChanged = false;
    };
    NetworkManager-dispatcher = {
      enable = false;
      restartIfChanged = false;
    };
    ModemManager = {
      enable = false;
      restartIfChanged = false;
    };
  };

 #Service config 


 #Configure keymap in X11
 services.xserver.layout = "us";
 services.xserver.xkbOptions = "eurosign:e";

 #Sound
 sound.enable = true;
 sound.mediaKeys.enable = true;
 hardware.pulseaudio.enable = true;
 hardware.bluetooth.enable = true;
 hardware.bluetooth.settings = {
 General = {
    Enable = "Source,Sink,Media,Socket";
    };
  };
  #Sound 

  #User options
  users.users.korner = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "mlocate" "wheel" "audio" "video" ];
  };

  programs.bash.shellAliases = {
   l = "ls -CF";
   dir = "dir --color=auto";
   vdir = "vdir --color=auto";
   grep = "grep --color=auto";
   fgrep = "fgrep --color=auto";
   egrep = "egrep --color=auto";
   ll = "ls -lh";
   ls = "ls --color=auto";
   flatpak = "flatpak --user";
 };
 #User options

 #Packages
 nixpkgs.config.allowUnfree = true;

 environment.pantheon.excludePackages = with pkgs; [
 onboard qgnomeplatform epiphany gnome.geary pantheon.switchboard-plug-a11y
 pantheon.elementary-tasks pantheon.elementary-print-shim pantheon.elementary-onboarding pantheon.elementary-mail
 pantheon.elementary-feedback pantheon.elementary-capnet-assist pantheon.elementary-camera
 ];
 
 services.locate = {
    enable = true;
    locate = pkgs.mlocate;
    interval = "hourly";
 };

 environment.systemPackages = with pkgs; [ 
 wget noto-fonts-cjk noto-fonts-extra lm_sensors htop time unrar strace mc
 wgetpaste psmisc lm_sensors cryptsetup powertop tree file git prelink
 ];
 #Packages

 system.stateVersion = "21.05";
}

