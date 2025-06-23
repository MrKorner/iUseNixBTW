{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  system = {
    switch.enableNg = true;
    switch.enable = false;
  };

  nix.settings.auto-optimise-store = true;

  environment.sessionVariables = { LIBVA_DRIVER_NAME = "iHD"; };
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [ intel-media-sdk ];
  };

  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    tmp.cleanOnBoot = true;
    tmp.useTmpfs = true;
    initrd.systemd.enable = true;
  };

  networking = {
    hostName = "nixosonchonk";
    networkmanager.enable = true;
    networkmanager.wifi.backend = "iwd";
    modemmanager.enable = false;
  };

  time.timeZone = "Europe/Prague";

  i18n.defaultLocale = "en_US.UTF-8";
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
  services = {
#	gnome.gnome-keyring.enable = true;
    scx.enable = true;
    scx.scheduler = "scx_lavd";
    desktopManager.plasma6.enable = true;
    displayManager.sddm.enable = true;
    displayManager.sddm.wayland.enable = true;
    pulseaudio.enable = false;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      wireplumber.enable = true;
    };
  };
  zramSwap = {
    enable = true;
    memoryPercent = 30;
    algorithm = "zstd";
  };

  security.rtkit.enable = true;

  users.users.chonktop = {
    isNormalUser = true;
    description = "chonktop";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.permittedInsecurePackages = [
    "olm-3.2.16"
  ];

  programs = {
    niri.enable = true;
    kdeconnect.enable = true;
    git.enable = true;
    steam.enable = true;
    steam.extraCompatPackages = with pkgs; [ proton-ge-bin ];
    corectrl.enable = true;
  };

  environment.systemPackages = with pkgs; [
    htop 
    intel-media-driver
    pciutils
    gnutar
    unrar
    time
    lm_sensors
    acpi
    usbutils
    psmisc
    file
    ffmpeg-full
    unzip
    nheko
    wgetpaste
    vlc
    freetube
    scribus
    libreoffice
    nixfmt-rfc-style
    deadnix
    mullvad-browser
    inkscape
    mindustry xwayland-satellite
  ];

  system.stateVersion = "25.05"; # Did you read the comment?

}
