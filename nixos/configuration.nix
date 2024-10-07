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
  boot.initrd.systemd.enable = true;
  system.switch.enableNg = true;
  system.switch.enable = false;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  boot.tmp.cleanOnBoot = true;
  boot.tmp.useTmpfs = true;
  nix.settings.auto-optimise-store = true;
  networking.networkmanager.plugins = lib.mkForce [];
  networking.networkmanager.enable = true;
  networking.networkmanager.wifi.backend = "iwd";
  systemd.network.wait-online.enable = false;
  systemd.oomd.enable = false;
  networking.hostName = "KornerOS";
  services.gvfs.enable = true;
  services.resolved.enable = true;
  services.emacs.package = pkgs.emacs-gtk;
  services.emacs.enable = true;
  programs.kdeconnect.enable = true;
  programs.wayfire.enable = true;
  programs.wayfire.plugins = with pkgs.wayfirePlugins; [
  wcm wayfire-plugins-extra wf-shell
  ];
  #services.displayManager.sddm.wayland.compositor = "weston";
  #services.desktopManager.plasma6.enableQt5Integration = false;
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



  services.xserver.enable = false;
  services.xserver.excludePackages = [ pkgs.xterm ];
  #services.xserver.desktopManager.lxqt.enable = true;
  xdg.portal.lxqt.enable = true;
  qt.platformTheme = "qt5ct";
  xdg.portal.wlr.enable = true;
  environment.variables = {QT_QPA_PLATFORMTHEME = "qt6ct";
			   GTK_THEME= "Adwaita:dark";   
			   WAYLAND_DISPLAY= "wayland=1";};
  #xdg.portal.extraPortals = [pkgs.xdg-desktop-portal-gtk];
  #services.displayManager.sddm.enable = true;
  #services.displayManager.sddm.wayland.enable = true;
  #services.desktopManager.plasma6.enable = true;
  #environment.plasma6.excludePackages = with pkgs.libsForQt5; [
  #oxygen khelpcenter plasma-browser-integration print-manager ];  
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

  zramSwap.enable = true;
  zramSwap.memoryPercent = 50;
  zramSwap.algorithm = "lz4";
  gtk.iconCache.enable = true;
  services.power-profiles-daemon.enable = true;
  programs.steam.enable = true;
  programs.gamescope.enable = true;
  programs.steam.extraCompatPackages = with pkgs; [ proton-ge-bin ];
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [ libxkbcommon glib libGL fontconfig xorg.libX11 freetype nss
  					   dbus nspr xorg.libXcomposite xorg.libXdamage xorg.libXfixes 
	   				   xorg.libXrender xorg.libXrandr xorg.libXtst libdrm xorg.libXi 
					   alsa-lib xorg.libxshmfence mesa xorg.libxkbfile krb5 xcb-util-cursor ];

  users.users.korner = {
    isNormalUser = true;
    description = "korner";
    extraGroups = ["networkmanager" "wheel" "video" "input" "plugdev"];
  };

  nixpkgs.config.allowUnfree = true;
 
  environment.systemPackages = with pkgs; [
    noto-fonts-cjk noto-fonts-emoji lm_sensors htop time unrar gnutar pciutils prismlauncher vlc ckan wdisplays kdePackages.breeze-icons
    acpi usbutils wgetpaste psmisc file git mc fastfetch ffmpeg-full lxqt.qterminal lxqt.pcmanfm-qt grim slurp
    lxqt.pavucontrol-qt lxqt.lxqt-policykit lxqt.qps lxqt.lxqt-archiver dconf-editor kanshi wlr-randr
    freetube vintagestory element-desktop osu-lazer-bin qt6ct epiphany flat-remix-icon-theme mako

  ];
system.stateVersion = "22.11";
}
