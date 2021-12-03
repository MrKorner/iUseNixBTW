{ config, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix];

  #Networking
  networking.hostName = "nixos";
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
  #networking.interfaces.enp3s0.useDHCP = true;
  #networking.interfaces.wlp5s0.useDHCP = true;
  time.timeZone = "Europe/Prague";
  #Networking

  #Desktop shenanigan
   programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    extraPackages = with pkgs; [
    slurp grim wl-clipboard imv
    alacritty brightnessctl bemenu
    ];
  };

  programs.steam.enable = true;
  services.xserver.enable = false;
  services.udisks2.enable = false; 

  #Hard Soft shenanigans
  services.getty.autologinUser = "korner";
  zramSwap.enable = true;
  zramSwap.memoryPercent = 75;
  hardware.opengl.enable = true;
  hardware.opengl.driSupport = true;
  hardware.opengl.driSupport32Bit = true;
  services.power-profiles-daemon.enable = true;
  nix.maxJobs = 8;
 
  #Boot shenanigans
    boot.loader = {
    systemd-boot.enable = false;
    efi = {
      canTouchEfiVariables = true;
    };
    grub = {
      efiSupport = true;
      efiInstallAsRemovable = false;
      device = "nodev";
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

  sound.mediaKeys.enable = true;
  hardware.bluetooth.enable = true;
  #Sound 

  #User options
  users.users.korner = {
    isNormalUser = true;
    extraGroups = [ "mlocate" "wheel" "audio" "video" "libvirtd" ];
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

 #VM stuff
 virtualisation.libvirtd.enable = true;
 programs.dconf.enable = true;
 virtualisation.spiceUSBRedirection.enable = true;
 #VM stuff  

 #Packages
 nixpkgs.config.allowUnfree = true;
 
 services.locate = {
    enable = true;
    locate = pkgs.mlocate;
    interval = "hourly";
 };

 environment.systemPackages = with pkgs; [ 
 wget noto-fonts-cjk noto-fonts-extra lm_sensors htop time unrar gnutar noto-fonts-emoji
 mc pulseaudio acpi usbutils bc chromium wgetpaste psmisc lm_sensors cryptsetup file git
 (appimageTools.wrapType2 {
  name = "gdlauncher";
  src = fetchurl {
    url = "https://github.com/gorilla-devs/GDLauncher/releases/download/v1.1.15/GDLauncher-linux-setup.AppImage";
    sha256 = "ffb32ac0269523c48943f3615d140787c1ee4783140a1ac4a50cc4177f812dac";
  };
    extraPkgs = pkgs: with pkgs; [ pipewire.lib ];
  })

 virt-manager irssi pavucontrol gnome.adwaita-icon-theme lsof bind
 wlr-randr mcomix3 deadbeef celluloid youtube-dl ffmpeg hakuneko
 jmtpfs tor-browser-bundle-bin
 ];
 #Packages

 system.stateVersion = "21.05";
}

