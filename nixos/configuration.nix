# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  nix.settings.extra-experimental-features = "nix-command flakes";

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  services.auto-cpufreq.enable = false;
  boot.tmp.cleanOnBoot = true;
  boot.tmp.useTmpfs = true;
  networking.networkmanager.plugins = lib.mkForce [];
  networking.networkmanager.enable = true;
  networking.networkmanager.wifi.backend = "iwd";
  systemd.network.wait-online.enable = false;
  systemd.oomd.enable = false;
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

  # Set your time zone.
  time.timeZone = "Europe/Prague";

  programs.bash.promptInit = ''PS1="\[\033[38;5;196m\]\\$\[$(tput sgr0)\][\[$(tput sgr0)\]\[\033[38;5;82m\]\A\[$(tput sgr0)\]]\[$(tput sgr0)\]\[\033[38;5;50m\]\u\[$(tput sgr0)\]@\[$(tput sgr0)\]\[\033[38;5;199m\]\H\[$(tput sgr0)\]\n\[$(tput sgr0)\]\[\033[38;5;226m\]>\w:\[$(tput sgr0)\]"'';
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

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.supportedLocales = ["en_US.UTF-8/UTF-8" "cs_CZ.UTF-8/UTF-8"];
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "cs_CZ.UTF-8";
    LC_IDENTIFICATION = "cs_CZ.UTF-8";
    LC_MEASUREMENT = "cs_CZ.UTF-8";
    LC_MONETARY = "cs_CZ.UTF-8";
    LC_NAME = "cs_CZ.UTF-8";
    LC_NUMERIC = "cs_CZ.UTF-8";
    LC_PAPER = "cs_CZ.UTF-8";
    LC_TELEPHONE = "cs_CZ.UTF-8";
    LC_TIME = "cs_CZ.UTF-8";
  };

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
    cpufreq = {
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



  services.xserver.enable = true;
  services.xserver.excludePackages = [ pkgs.xterm ];
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;
  environment.plasma5.excludePackages = with pkgs.libsForQt5; [
  oxygen khelpcenter plasma-browser-integration print-manager ];
  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  services.locate.localuser = null;
  services.locate = {
    enable = true;
    locate = pkgs.mlocate;
    interval = "hourly";
  };

  #virtualisation.podman.enable = true;
  #virtualisation.libvirtd.enable = true;
  zramSwap.enable = true;
  zramSwap.memoryPercent = 50;
  hardware.opengl.enable = true;
  hardware.opengl.driSupport = true;
  services.power-profiles-daemon.enable = true;

  programs.steam.enable = true;
  programs.steam.package = pkgs.steam-small;
  
  nixpkgs.overlays = [
    (import (builtins.fetchTarball {
      url = https://github.com/nix-community/emacs-overlay/archive/master.tar.gz;
    }))
  ];
  xdg.portal.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.korner = {
    isNormalUser = true;
    description = "korner";
    extraGroups = ["networkmanager" "wheel" "video" "input" "plugdev"];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    wget noto-fonts-cjk lm_sensors htop time unrar gnutar pciutils prismlauncher
    (pkgs.emacsUnstable.override {
      nativeComp = false;
      withPgtk = true;
      withX = false;
      withNS = false;
      withGTK2 = false;
      treeSitterPlugins = with pkgs.tree-sitter-grammars; [
      	tree-sitter-bash
	tree-sitter-nix
      ];
    })
    acpi usbutils wgetpaste psmisc cryptsetup file git mc lsof neofetch librewolf
    ffmpeg-full nheko btrfs-progs noto-fonts-emoji-blob-bin bc freetube inkscape nicotine-plus
  ];
  system.stateVersion = "22.11"; # Did you read the comment?
}
