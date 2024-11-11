{
  config,
  pkgs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
  ];

  nix.settings = {
    experimental-features = "nix-command flakes";
    auto-optimise-store = true;
  };

  security.rtkit.enable = true;
  hardware.bluetooth.enable = true;

  system = {
    switch.enableNg = true;
    switch.enable = false;
    stateVersion = "22.11";
  };

  time.timeZone = "Europe/Prague";
  qt.platformTheme = "qt5ct";

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      efi.efiSysMountPoint = "/boot/efi";
    };
    tmp.cleanOnBoot = true;
    tmp.useTmpfs = true;
    initrd.systemd.enable = true;
  };

  services = {
    pipewire = {
      enable = true;
      wireplumber.enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    power-profiles-daemon.enable = true;
    locate.localuser = null;
    locate = {
      enable = true;
      package = pkgs.mlocate;
      interval = "hourly";
    };
    xserver.enable = false;
    upower.enable = false;
    gvfs.enable = true;
    resolved.enable = true;
    dbus.implementation = "broker";
    emacs.package = pkgs.emacs-gtk;
    emacs.enable = true;
  };

  programs = {
    git.enable = true;
    steam.enable = true;
    gamescope.enable = true;
    steam.extraCompatPackages = with pkgs; [ proton-ge-bin ];
    wayfire.enable = true;
    wayfire.plugins = with pkgs.wayfirePlugins; [
      wcm
      wayfire-plugins-extra
      wf-shell
    ];
  };

  xdg = {
    portal = {
      enable = true;
      wlr.enable = true;
      config = {
        common = {
          default = [ "gtk" ];
          "org.freedesktop.ScreenSaver" = [ "none" ];
          "org.freedesktop.impl.portal.ScreenCast" = [ "wlr" ];
          "org.freedesktop.impl.portal.Screenshot" = [ "wlr" ];
        };
      };
    };
  };

  networking = {
    networkmanager.enable = false;
    networkmanager.wifi.backend = "iwd";
    hostName = "KornerOS";
    useDHCP = false;
    wireless = {
      iwd.enable = true;
      iwd.settings = {
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
    };
  };

  programs.bash = {
    promptInit = ''PS1="\[\033[38;5;196m\]\\$\[$(tput sgr0)\][\[$(tput sgr0)\]\[\033[38;5;82m\]\A\[$(tput sgr0)\]]\[$(tput sgr0)\]\[\033[38;5;50m\]\u\[$(tput sgr0)\]@\[$(tput sgr0)\]\[\033[38;5;199m\]\H\[$(tput sgr0)\]\n\[$(tput sgr0)\]\[\033[38;5;226m\]>\w:\[$(tput sgr0)\]"'';
    shellAliases = {
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
  };
  i18n = {
    defaultLocale = "en_US.UTF-8";
    supportedLocales = [
      "en_US.UTF-8/UTF-8"
      "cs_CZ.UTF-8/UTF-8"
    ];
    extraLocaleSettings = {
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
  };

  systemd = {
    oomd.enable = false;
    services = {
      NetworkManager-dispatcher = {
        enable = false;
        restartIfChanged = false;
      };
      NetworkManager-wait-online = {
        enable = false;
        restartIfChanged = false;
      };
      ModemManager = {
        enable = false;
        restartIfChanged = false;
      };
    };
  };

  environment.variables = {
    QT_QPA_PLATFORMTHEME = "qt6ct";
    GTK_THEME = "Adwaita:dark";
    XDG_CURRENT_DESKTOP = "wayfire";
  };

  virtualisation = {
    containers.enable = true;
    podman = {
      enable = true;
    };
  };

  zramSwap = {
    enable = true;
    memoryPercent = 50;
    algorithm = "zstd";
  };

  users.users.korner = {
    isNormalUser = true;
    description = "korner";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };

  fonts.packages = with pkgs; [
    noto-fonts-cjk-sans
    noto-fonts-emoji
  ];
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    (pkgs.emacs-gtk.overrideAttrs (old: {
      configureFlags = old.configureFlags ++ [
        "--with-native-compilation=aot"
      ];
    }))
    lm_sensors
    htop
    time
    unrar
    gnutar
    pciutils
    prismlauncher
    vlc
    ckan
    epiphany
    statix
    deadnix
    wdisplays
    acpi
    usbutils
    wgetpaste
    psmisc
    file
    mc
    fastfetch
    ffmpeg-full
    qt6ct
    grim
    slurp
    terminator
    kanshi
    wlr-randr
    freetube
    vintagestory
    element-desktop
    osu-lazer-bin
    flat-remix-icon-theme
    mako
    unzip
    distrobox
    kdePackages.breeze-icons
    p7zip
    lxqt.pcmanfm-qt
    lxqt.pavucontrol-qt
    lxqt.lxqt-policykit
    lxqt.qps
    nixfmt-rfc-style
    lxqt.lxqt-panel
    lxqt.lximage-qt
    lxqt.lxqt-archiver
  ];
}
