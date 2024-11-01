{
  config,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
  ];

  nix.settings.extra-experimental-features = "nix-command flakes";
  boot.initrd.systemd.enable = true;
  hardware.bluetooth.enable = true;
  services.upower.enable = true;
  system.switch.enableNg = true;
  system.switch.enable = false;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  boot.tmp.cleanOnBoot = true;
  boot.tmp.useTmpfs = true;
  nix.settings.auto-optimise-store = true;
  networking.networkmanager.plugins = lib.mkForce [ ];
  networking.networkmanager.enable = true;
  networking.networkmanager.wifi.backend = "iwd";
  systemd.network.wait-online.enable = false;
  systemd.oomd.enable = false;
  networking.hostName = "KornerOS";
  services.gvfs.enable = true;
  services.resolved.enable = true;
  services.emacs.package = pkgs.emacs-gtk;
  services.emacs.enable = true;
  programs.wayfire.enable = true;
  programs.wayfire.plugins = with pkgs.wayfirePlugins; [
    wcm
    wayfire-plugins-extra
    wf-shell
  ];
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
  i18n.supportedLocales = [
    "en_US.UTF-8/UTF-8"
    "cs_CZ.UTF-8/UTF-8"
  ];
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

  services.xserver.enable = false;
  services.xserver.excludePackages = [ pkgs.xterm ];
  qt.platformTheme = "qt5ct";
  xdg.portal.wlr.enable = true;
  environment.variables = {
    QT_QPA_PLATFORMTHEME = "qt6ct";
    GTK_THEME = "Adwaita:dark";
    XDG_CURRENT_DESKTOP = "wayfire";
  };
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
    package = pkgs.mlocate;
    interval = "hourly";
  };

  virtualisation.containers.enable = true;
  virtualisation = {
    podman = {
      enable = true;
    };
  };
  zramSwap.enable = true;
  zramSwap.memoryPercent = 50;
  zramSwap.algorithm = "lz4";
  gtk.iconCache.enable = true;
  services.power-profiles-daemon.enable = true;
  programs.steam.enable = true;
  programs.gamescope.enable = true;
  programs.steam.extraCompatPackages = with pkgs; [ proton-ge-bin ];
  users.users.korner = {
    isNormalUser = true;
    description = "korner";
    extraGroups = [
      "networkmanager"
      "wheel"
      "video"
      "input"
      "plugdev"
    ];
  };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    noto-fonts-cjk-sans
    noto-fonts-emoji
    lm_sensors
    htop
    time
    unrar
    gnutar
    pciutils
    prismlauncher
    vlc
    ckan
    wdisplays
    acpi
    usbutils
    wgetpaste
    psmisc
    file
    git
    mc
    fastfetch
    ffmpeg-full
    lxqt.qterminal
    lxqt.pcmanfm-qt
    grim
    slurp
    lxqt.pavucontrol-qt
    lxqt.lxqt-policykit
    lxqt.qps
    lxqt.lximage-qt
    lxqt.lxqt-archiver
    kanshi
    wlr-randr
    kdePackages.breeze-icons
    freetube
    vintagestory
    element-desktop
    osu-lazer-bin
    qt6ct
    epiphany
    flat-remix-icon-theme
    mako
    nixfmt-rfc-style
    distrobox
  ];
  system.stateVersion = "22.11";
}

