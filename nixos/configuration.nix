{ config, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix];

  #Networking
  networking.hostName = "nixos";
  networking.wireless.iwd.enable = true;
  networking.useDHCP = true;
  networking.interfaces.enp3s0.useDHCP = true;
  networking.interfaces.wlp5s0.useDHCP = true;
  time.timeZone = "Europe/Prague";
  #Networking

  #Desktop shenanigans
   programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    extraPackages = with pkgs; [
    swaylock slurp grim
    wl-clipboard moc imv
    alacritty brightnessctl wl-clipboard
    bemenu ncpamixer
    ];
  };
  programs.steam.enable = true;
  services.xserver.enable = false;
  hardware.steam-hardware.enable = true;
  services.udisks2.enable = false; 
  
  #Hard Soft shenanigans
  zramSwap.enable = true;
  zramSwap.memoryPercent = 75;
  hardware.opengl.enable = true;
  hardware.opengl.extraPackages = with pkgs; [ vaapiIntel amdvlk ];
  hardware.opengl.driSupport = true;
  hardware.opengl.driSupport32Bit = true;
  services.power-profiles-daemon.enable = true;

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

 #Configure keymap in X11
 services.xserver.layout = "us";
 services.xserver.xkbOptions = "eurosign:e";

 #Sound
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;

    # High quality BT calls
    media-session.config.bluez-monitor.rules = [
      {
        # Matches all cards
        matches = [{ "device.name" = "~bluez_card.*"; }];
        actions = {
          "update-props" = {
            "bluez5.auto-connect" = [ "hfp_hf" "hsp_hs" "a2dp_sink" ];
          };
        };
      }
      {
        matches = [
          # Matches all sources
          { "node.name" = "~bluez_input.*"; }
          # Matches all outputs
          { "node.name" = "~bluez_output.*"; }
        ];
        actions = {
          "node.pause-on-idle" = false;
        };
      }
    ];
  };
 sound.mediaKeys.enable = true;
 hardware.bluetooth.enable = true;
 hardware.bluetooth.hsphfpd.enable = true;
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
   la = "ls -a";
   ll = "ls -lh";
   ls = "ls --color=auto";
   flatpak = "flatpak --user";
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
 wget noto-fonts-cjk noto-fonts-extra lm_sensors htop time unrar
 strace mc neofetch pulseaudio acpi usbutils lshw prelink bc chromium
 wgetpaste psmisc lm_sensors cryptsetup powertop tree file git appimage-run
 ];
 #Packages

 system.stateVersion = "21.05";
}

