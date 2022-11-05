{ config, pkgs, lib, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];
  #Networking
  networking.networkmanager.enable = true;
  networking.networkmanager.plugins = [ ];
  networking.networkmanager.wifi.backend = "iwd";
  networking.hostName = "KornerOS";
  services.resolved.enable = true;
  networking.wireless.iwd.enable = true;
  networking.wireless.iwd.settings = {
   Network = {
    EnableIPv6 = false;
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
  services.xserver.desktopManager.xfce.enable = true;
  programs.dconf.enable = true;
  services.xserver.enable = true;
  services.xserver.excludePackages = [ pkgs.xterm ];
  services.xserver.displayManager.lightdm.enable = true;
  # services.udisks2.enable = false;
  # programs.sway = {
  #  enable = true;
  #  wrapperFeatures.gtk = true;
  #  extraPackages = with pkgs; [
  #  slurp grim wl-clipboard wf-recorder
  #  alacritty brightnessctl bemenu
  #  ];
  #};
  #services.xserver.desktopManager.plasma5.excludePackages = with pkgs.libsForQt5; [
  # oxygen
  # khelpcenter
  # plasma-browser-integration
  # print-manager
  # ];
  #Hardware soft options
  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  services.flatpak.enable = true;
  #services.getty.autologinUser = "korner";
  environment.sessionVariables = rec {
    XDG_CACHE_HOME  = "\${HOME}/.cache";
    XDG_CONFIG_HOME = "\${HOME}/.config";
    XDG_BIN_HOME    = "\${HOME}/.local/bin";
    XDG_DATA_HOME   = "\${HOME}/.local/share";
  };

  virtualisation.podman.enable = true;
  zramSwap.enable = true;
  zramSwap.memoryPercent = 95;
  hardware.opengl.enable = true;
  hardware.opengl.driSupport = true;
  services.power-profiles-daemon.enable = true;
  #Boot stuff
  boot.loader = {
   systemd-boot.enable = true;
   efi = {
    canTouchEfiVariables = true;
   };
  };
  #Boot stuff

 #Sound
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    wireplumber.enable = true;
    enable = true;
    pulse.enable = true;
    alsa.enable = true;
  };

  systemd.services = {
    alsa-store = {
      enable = false;
      restartIfChanged = false;
    };
  };
 #Sound

  systemd.services = {
    NetworkManager-dispatcher = {
      enable = false;
      restartIfChanged = false;
    };
  };
  systemd.services = {
    NetworkManager-wait-online = {
      enable = false;
      restartIfChanged = false;
    };
  };
 systemd.services = {
    ModemManager = {
      enable = false;
      restartIfChanged = false;
    };
  };


  hardware.bluetooth.enable = true;

  #User options
  users.users.korner = {
    isNormalUser = true;
    extraGroups = [ "wheel" "audio" "video" "input" "plugdev"];
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

 environment.systemPackages = with pkgs; [ 
  wget noto-fonts-cjk noto-fonts-extra lm_sensors htop time unrar gnutar noto-fonts-emoji pciutils
  acpi usbutils wgetpaste psmisc cryptsetup file git pulseaudio mc lsof neofetch kate ark
  ];
  #Packages

  system.stateVersion = "22.05";

}
