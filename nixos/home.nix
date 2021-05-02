{ config, pkgs, ... }:
{
  home.username = "korner";
  home.stateVersion = "21.05";
  home.homeDirectory = "/home/korner";
  
  programs = {
    home-manager.enable = true;
    waybar.enable = true;
    tmux.enable = true;
  };

  xdg = {
    enable = true;
    configFile =
      pkgs.lib.mapAttrs'
        (name: _: pkgs.lib.nameValuePair name { recursive = true; source = "${./config}/${name}"; })
        (builtins.readDir ./config);
  };
}
