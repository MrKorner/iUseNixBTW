{ config, pkgs, lib, ... }:

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
  time.timeZone = "Europe/Prague";
  #Networking

  #Desktop shenanigan
   programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    extraPackages = with pkgs; [
    slurp grim wl-clipboard imv
    alacritty brightnessctl bemenu
    wlr-randr mc
    ];
  };

  programs.steam.enable = true;
  #Hard Soft shenanigans
  services.getty.autologinUser = "korner";
  zramSwap.enable = true;
  zramSwap.memoryPercent = 75;
  hardware.opengl.enable = true;
  hardware.opengl.driSupport = true;
  hardware.opengl.driSupport32Bit = true;
  services.power-profiles-daemon.enable = true;
 
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
   flatpak = "flatpak --user";
 };
 #User options

 #VM stuff
 #virtualisation.libvirtd.enable = true;
 #virtualisation.spiceUSBRedirection.enable = true;
 #VM stuff  

 #Packages
 nixpkgs.config.allowUnfree = true;
 
 services.locate = {
    enable = true;
    locate = pkgs.mlocate;
    interval = "hourly";
 };

 environment.systemPackages = with pkgs; [ 
 wget noto-fonts-cjk noto-fonts-extra lm_sensors htop time unrar gnutar noto-fonts-emoji intel-gpu-tools
 acpi usbutils chromium wgetpaste psmisc cryptsetup file git ffmpeg  pavucontrol pulseaudio
 irssi gnome.adwaita-icon-theme lsof bind mcomix3 youtube-dl hakuneko celluloid deadbeef

 (appimageTools.wrapType2 {
  name = "gdlauncher";
  src = fetchurl {
    url = "https://github.com/gorilla-devs/GDLauncher/releases/download/v1.1.18/GDLauncher-linux-setup.AppImage";
    sha256 = "0vbcdfk6yf4252cp3k62y6p8fg9dxbbp5rrg9ql2c7gdly3cvbn2";
  };
    extraPkgs = pkgs: with pkgs; [ pipewire.lib ];
  })
 ];
 #Packages

 system.stateVersion = "21.05";
}


