{ config, pkgs, ... }:
let pkgBin = name: "${pkgs.${name}}/bin/${name}"; in
{
  imports =
    [
      ./hardware-configuration.nix
      <home-manager/nixos>
    ];
  nixpkgs.config.allowUnfree = true;

  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    users.korner = import ./home.nix;
  };

  users.users.korner = {
    isNormalUser = true;
    extraGroups = [ "wheel" "video" "networkmanager" "audio" ];
  };

  boot.loader = {
    efi = {
      canTouchEfiVariables = false;
    };
    grub = {
      efiSupport = true;
      efiInstallAsRemovable = true;
      device = "nodev";
    };
  };
  networking.firewall.enable = false;
  networking.networkmanager.enable = true;
  networking.hostName = "nixos";
  time.timeZone = "Europe/Prague";

  hardware.bluetooth.enable = true;
  hardware.opengl.driSupport = true;
  hardware.opengl.driSupport32Bit = true;
  hardware.pulseaudio.support32Bit = true;
  hardware.opengl.enable = true;

  programs.light.enable = true;
  programs.dconf.enable = true;
  programs.steam.enable = true;
  programs.java.enable = true;
  programs.sway = {                                                                                                                                                                                           
     enable = true;                                                                                                                                                                                               
     wrapperFeatures.gtk = true;                                                                    
  };  
  xdg = {
    portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-wlr
        xdg-desktop-portal-gtk
      ];
      gtkUsePortal = true;
    };
  };

  zramSwap.enable = true;
  zramSwap.memoryPercent = 75;
  security.rtkit.enable = true;
  sound.mediaKeys.enable = true;

  services.xserver.videoDrivers = [ "modesetting" "amdgpu" ];
  services.blueman.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  services.thermald.enable = true;
  services.gnome3.gnome-keyring.enable = true;

  systemd.services = {
    NetworkManager-wait-online = {
      enable = false;
      restartIfChanged = false;
    };
    NetworkManager-dispatcher = {
      enable = false;
      restartIfChanged = false;
    };
    ModemManager = {
      enable = false;
      restartIfChanged = false;
    };
  };

  environment.sessionVariables = {
    MOZ_ENABLE_WAYLAND = "1";
  };
  environment.systemPackages = with pkgs; [
    mlocate multimc micro pulseaudio
    noto-fonts-cjk noto-fonts-extra lm_sensors
    celluloid pfetch htop time gimp gthumb wget
    firefox-wayland evince transmission teams unrar
    gnome3.dconf-editor powertop mc cryptsetup git
    polkit_gnome wirelesstools deadbeef pavucontrol
    wf-recorder wl-clipboard freetube psmisc lutris                                                                                    
    swaybg slurp wofi kitty mako grim slurp swaylock
  ];

  system.stateVersion = "20.09";
}
