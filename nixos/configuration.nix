	{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
  ];

  nix.settings.extra-experimental-features = "nix-command flakes";

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

  zramSwap.enable = true;
  zramSwap.memoryPercent = 50;
  zramSwap.algorithm = "lz4";
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

  users.users.korner = {
    isNormalUser = true;
    description = "korner";
    extraGroups = ["networkmanager" "wheel" "video" "input" "plugdev"];
  };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    noto-fonts-cjk lm_sensors htop time unrar gnutar pciutils prismlauncher
    acpi usbutils wgetpaste psmisc cryptsetup file git mc neofetch librewolf
    corectrl ffmpeg-full nheko freetube
    (pkgs.tor-browser-bundle-bin.override {
    useHardenedMalloc = false;
    })

    ((pkgs.emacsUnstable.override {
     nativeComp = false;
     withPgtk = true;
     withX = false;
     withNS = false;
     withGTK2 = false;
     }).overrideAttrs (old: {
     configureFlags =
         old.configureFlags
         ++ [
           "--without-games"
           "--without-emulation"
         ];
     }))
  ];
  system.stateVersion = "22.11";
}
